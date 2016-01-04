#!/bin/bash -e

#~# QMUL CentOS 6 Drupal Application run script
#
# Log:
# 2015-11-23 kevina: v1.0 Created
# 2015-11-25 I.Price@qmul.ac.uk: Added auto documenting comments see docker_qmul/docs for README

VER="v1.0"
clear
#~# Install pwgen for auto generated passwords
# Some of the passwords need to be automatically generated.  Ensure pwgen is installed first, otherwise install it
[ ! -f /usr/bin/pwgen ] && echo -e 'Installing pwgen' && yum -y -q install pwgen && [ -f /usr/bin/pwgen ] && echo 'pwgen installed successfully'

#-# Validate db name funtion
function db_name_validate {
	printf '\nWhat database name would you like to use for this Drupal installation? '
	read -r db_name
	db_name_length=$(echo ${#db_name})

	# Ensure the input is 5 or more characters in length, and that the input is strictly alphanumeric only
	if [ $db_name_length -lt 5 ]
	then
		echo 'Please choose a database name greater than 4 characters' && unset db_name && db_name_validate
	fi

	if echo $db_name | grep -q '[^0-9a-zA-Z]'
	then
		echo 'Please only use alphanumeric characters'  && unset db_name && db_name_validate
	fi
}

#~# Validate user name function
function db_user_validate {
	printf 'What MySQL username would you like to use in order to access '$db_name'? '
	read -r db_user
	db_user_length=$(echo ${#db_user})

	# Ensure the input is 5 or more characters in length, and that the input is strictly alphanumeric only
        if [ $db_user_length -lt 5 ]
        then
                echo 'Please choose a MySQL username greater than 4 characters' && unset db_name && db_user_validate
        fi

        if echo $db_user | grep -q '[^0-9a-zA-Z]'
        then
		echo 'Please only use alphanumeric characters'  && unset db_user && db_user_validate
        fi
}

#~# Validate docker name function
function docker_name_validate {
	printf 'What name would you like to give the instance? (e.g. qmul-web-1) (Used by Docker only) '
	read -r docker_name
        docker_name_length=$(echo ${#docker_name})

	# Ensure the input is 6 or more characters in length, and that the input is strictly alphanumeric only
	if [ $docker_name_length -lt 6 ]
	then
		echo 'Please choose a name greater than 5 characters' && unset docker_name && docker_name_validate
	fi

	if echo $docker_name | grep -q '[^0-9a-zA-Z]'
		then echo 'Please only use alphanumeric characters'  && unset docker_name && docker_name_validate
	fi

	#~# TODO - K AUSTIN: Check existing container names to prevent duplication.
}

#~# Run functions 
# Run through the functions above to build up variables required for the post-install.  Auto-generate sensitive passwords.
db_name_validate
db_user_validate
docker_name_validate
db_user_pass=$(pwgen -Bvs 12 1)
db_root_pass=$(pwgen -Bvs 12 1)
drupal_admin_pass=$(pwgen -Bvs 12 1)

#~# TODO Hardcode ports to 3307 2200 8000
# Until we clarify how we'll port-map, have hard-coded these values.  This needs to be revisited soon. (K Austin, 24/11/2015)
R_PORT_MYSQL=3307
R_PORT_SSH=2200
R_PORT_HTTP=8000


#~# Start the container
docker_id=$(docker run -d -p $R_PORT_HTTP:80 -p $R_PORT_SSH:22 -p $R_PORT_MYSQL:3306 --name $docker_name -e DRUPAL_MYSQL_DB=$db_name -e DRUPAL_MYSQL_USER=$db_user -e DRUPAL_MYSQL_PASS=$db_user_pass -e DRUPAL_ADMIN_PASS=$drupal_admin_pass qmul/centos6_app_drupal:v1.1)
echo -e "\nThe container for $docker_name has started"

docker_ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' $docker_id)

# Give MySQL time to come online.
echo "Waiting for MySQL to start"
docker exec -it $docker_id bash -c "until mysqladmin ping &>dev/null; do echo -n "."; sleep 0.3; done"

#~# Update MySQL with login credentials and replicate 'mysql_safe_installation' to prevent passwordless entry
echo -e "\nUpdating MySQL"
docker exec -it $docker_id bash -c 'mysqldump --user=admin -pchangeme drupal > /var/www/drupal_dump.sql'
docker exec -it $docker_id mysql --user=admin -pchangeme --execute="DROP DATABASE drupal"
docker exec -it $docker_id mysql --user=admin -pchangeme --execute="CREATE DATABASE $db_name"
docker exec -it $docker_id bash -c "mysql --user=admin -pchangeme $db_name < /var/www/drupal_dump.sql"
docker exec -it $docker_id bash -c 'rm -f /var/www/drupal_dump.sql'
docker exec -it $docker_id mysql --user=admin -pchangeme --execute="GRANT ALL ON *.* TO '$db_user'@'localhost' IDENTIFIED BY '$db_user_pass' WITH GRANT OPTION"
docker exec -it $docker_id mysql --user="$db_user" -p"$db_user_pass" --execute="DELETE FROM mysql.user WHERE User='admin'"
docker exec -it $docker_id mysql --user="$db_user" -p"$db_user_pass" --execute="DELETE FROM mysql.user WHERE User=''"
docker exec -it $docker_id mysql --user="$db_user" -p"$db_user_pass" --execute="UPDATE mysql.user SET Password=PASSWORD('$db_root_pass') WHERE User='root'"
docker exec -it $docker_id mysql --user="$db_user" -p"$db_user_pass" --execute="DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
docker exec -it $docker_id mysql --user="$db_user" -p"$db_user_pass" --execute="DROP DATABASE test"
docker exec -it $docker_id mysql --user="$db_user" -p"$db_user_pass" --execute="FLUSH PRIVILEGES"

#~# Update /var/www/sites/default/settings.php and use Drush to update admin password
echo -e "\nUpdating Drupal configuration file and admin password"

docker exec -it $docker_id sed -i "s/'database' => 'drupal'/'database' => '$db_name'/" /var/www/html/sites/default/settings.php
docker exec -it $docker_id sed -i "s/'username' => 'admin'/'username' => '$db_user'/" /var/www/html/sites/default/settings.php
docker exec -it $docker_id sed -i "s/'password' => 'changeme'/'password' => '$db_user_pass'/" /var/www/html/sites/default/settings.php
docker exec -it $docker_id bash -c 'cd /var/www/html; drush upwd admin --password="$DRUPAL_ADMIN_PASS"'

#~# Finished update.  Let the user know the details.
echo -e "\nYour Drupal instance is now ready to use.  Please make a note of the following details below in case you require them in the future:\n"
echo "MySQL database: $db_name"
echo "MySQL user: $db_user"
echo "MySQL pass: $db_user_pass"
echo "MySQL root pass: $db_root_pass"
echo "Drupal user: admin"
echo "Drupal pass: $drupal_admin_pass"
echo "Docker name: $docker_name"
echo "Docker ID: $docker_id"
echo "Docker IP: $docker_ip"
echo "HTTP Port: $R_PORT_HTTP"
echo "SSH Port: $R_PORT_SSH"
echo "MySQL Port: $R_PORT_MYSQL"

echo -e "\nTo use Docker to access this instance use this command: \e[31mdocker exec -it $docker_name /bin/bash\e[0m"
echo -e "\nTo log into your new Drupal application, please visit \e[31mhttp://$docker_ip/user\e[0m using the Drupal user and Drupal pass values above."
echo -e "\nFor support please refer to the wiki, or contact helpdesk@qmul.ac.uk\n"
