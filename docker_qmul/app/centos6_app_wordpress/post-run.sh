#!/bin/bash -e

#~# QMUL Docker container POST creation script
#
# 2016-01-04 K.Austin@qmul.ac.uk : Original file

wt="Queen Mary University London Docker Deployer" # dialog title
wh=24 # dialog height
wl=80 # dialog length
bt=""
bold=$(tput bold)
normal=$(tput sgr0)
build_time=$(date)
docker_id=$(cat docker_id)
docker_ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' $docker_id)
docker_ports=$(docker inspect --format '{{.NetworkSettings.Ports}}' $docker_id)

#~# MySQL Configuration - ALWAYS REQUIRED.
mysql_root_pass=$(pwgen -Bvs 12 1)
 summary_box="** Waiting for MySQL to start..."
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
sleep 0.5
docker exec -it $docker_id bash -c "until mysqladmin ping &>dev/null;do echo -n ""; sleep 0.1; done"
 summary_box+=" Done\n"
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
sleep 0.5
 summary_box+="** Securing MySQL..."
sleep 0.5
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
docker exec -it $docker_id mysql --user="root" --execute="UPDATE mysql.user SET Password=PASSWORD('$mysql_root_pass') WHERE User='root'"
docker exec -it $docker_id mysql --user="root" --execute="DELETE FROM mysql.user WHERE User='admin'"
docker exec -it $docker_id mysql --user="root" --execute="DELETE FROM mysql.user WHERE User=''"
docker exec -it $docker_id mysql --user="root" --execute="DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
docker exec -it $docker_id mysql --user="root" --execute="DROP DATABASE test"
docker exec -it $docker_id mysql --user="root" --execute="FLUSH PRIVILEGES"
 summary_box+=" Done\n"
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
sleep 2

#~# Custom configuration specifically for the application.  Feel free to add anything into this section.
docker exec -it $docker_id mysql --user="root" -p$mysql_root_pass --execute="CREATE DATABASE wordpress"
docker exec -it $docker_id bash -c 'cp -rf /usr/share/wordpress/* /var/www/html/'
docker exec -it $docker_id bash -c 'chown -R apache.apache /var/www/html/*'
docker exec -it $docker_id sed -i 's/database_name_here/wordpress/' /etc/wordpress/wp-config.php
docker exec -it $docker_id sed -i 's/username_here/root/' /etc/wordpress/wp-config.php
docker exec -it $docker_id sed -i "s/password_here/$mysql_root_pass/" /etc/wordpress/wp-config.php
# End custom configuration.

#~# Puppet Configuration - ALWAYS REQUIRED.
 summary_box+="** Configuring Puppet Access..."
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
docker exec -it $docker_id puppet agent --onetime
 summary_box+=" Done\n"
 dialog --title "$wt" --infobox "$summary_box" $wh $wl --and-widget --msgbox "To configure Puppet, please follow these commands:\n\n1. SSH into mgt-pup-01\n\n2. Escalate to root\n\n3. # echo node $instance_name inherits containernode { } >> /etc/puppet/manifests/containers.pp\n\n4. # puppet cert sign $instance_name.server.qmul.ac.uk\n\n\nClick <OK> to continue." 20 100

#~# SSH Configuration - ALWAYS REQUIRED.
 summary_box+="** Configuring SSH..."
sleep 0.5
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
docker exec -it $docker_id rm -f /root/.ssh/id_rsa
docker exec -it $docker_id rm -f /root/.ssh/id_rsa.pub
docker exec -it $docker_id ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa -q
 summary_box+=" Done\n"
sleep 0.5

#~# Output of container details - ALWAYS REQUIRED.
file_summary="Instance Name: $instance_name"
file_summary+="\nFQDN: $fqdn"
file_summary+="\nBrief Description: $description"
file_summary+="\nDocker Image: $selected_image"
file_summary+="\nDocker Container ID: $docker_id"
file_summary+="\nDocker IP Address (Internal): $docker_ip"
file_summary+="\nIP Address (External): $ip_address_allocated"
file_summary+="\nDocker Ports: $docker_ports"
sudo_user_length=$(echo ${#SUDO_USER})
	if [ $sudo_user_length -lt 1 ]
		then
			file_summary+="\nBuilt by: $creator <$email> (sudo user: NOT SET, sudo ID: NOT SET)"
		else
			file_summary+="\nBuilt by: $creator <$email> (sudo user: $SUDO_USER, sudo id: $SUDO_UID)"
        fi

file_summary+="\nManager: $manager"
helpdesk_length=$(echo ${#helpdesk})
	if [ $helpdesk_length -gt 0 ]
		then
			file_summary+="\nHelpdesk Ticket: $helpdesk"
	fi

file_summary+="\nBuild time: $build_time"
file_summary+="\nMySQL Root User: root"
file_summary+="\nMySQL Root Password: $mysql_root_pass"
echo -e $file_summary > qmul_container_info
docker cp qmul_container_info $docker_id:/etc/qmul_container_info

#~# Additional tasks including IPAM and updating /etc/hosts.
 summary_box+="** Allocating IP Address..."
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
sed -i.bkp "/\# Docker end/i $ip_address_allocated /$instance_name $fqdn" /etc/hosts

mysql -u root -e "UPDATE qmul.ipam SET status = 1, fqdn=\"$fqdn\", short_name=\"$instance_name\" WHERE ip_address=\"$ip_address_allocated\""

 summary_box+=" Done\n"
 dialog --title "$wt" --infobox "$summary_box" $wh $wl
 summary_box+="** Finishing Configuration..."
sleep 0.5
 summary_box+=" Done\n"
 dialog --title "$wt" --infobox "$summary_box" $wh $wl

#~# Append this process to /var/log/docker_audit.log.
l1=$(date "+%b %e %T")
l2=$(uname -n)
sudo_length=$(echo ${#SUDO_USER})
if [ $sudo_length -lt 1 ]
	then
		echo -e "$l1 $l2 docker: Container name ($instance_name) (FQDN: $fqdn) (ID: $docker_id) started by $creator (NO SUDO_USER) using $selected_image" >> /var/log/docker_audit.log
	else
		echo -e "$l1 $l2 docker: Container name ($instance_name) (FQDN: $fqdn) (ID: $docker_id) started by $creator ($SUDO_USER) using $selected_image" >> /var/log/docker_audit.log
fi

#~# Restart the container so it triggers the network changes required (macvlan) - ALWAYS REQUIRED.
docker restart $docker_id

#~# Present output to user - ALWAYS REQUIRED.
 summary_box+="\n\n*** Your new container is now ready to use.  Click <OK> to exit this script and to view your container information. ***"
 dialog --title "$wt" --msgbox "$summary_box" $wh $wl
clear
cat qmul_container_info
echo -e "\n\nThis information has also been copied over to ${bold}/etc/qmul_container_info${normal} on your container."
echo -e "\nTo access your new container you can use this command: ${bold}docker exec -it $instance_name /bin/bash${normal}"
echo -e "\nTo finish Puppet joining this container you can use this command: ${bold}docker exec -it $instance_name puppet agent -t${normal}"
echo -e "\nFor support please refer to the wiki at http://wiki.its.qmul.ac.uk/web-technologies/docker_lamp, or contact helpdesk@qmul.ac.uk\n"

#~# Tidy up.
rm -f qmul_container_info
rm -f docker_id
