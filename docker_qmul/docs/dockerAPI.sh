if [[ -z ${1} ]]
  then
    CMD="images"
  else
    CMD=${1}
fi

echo -e "GET /${1}/json?all=1?size=1 HTTP/1.1\r\n" | nc -U /var/run/docker.sock | tail -n +8 | head -n +1 | python -m json.tool



# all – 1/True/true or 0/False/false, Show all containers. Only running containers are shown by default (i.e., this defaults to false)
# limit – Show limit last created containers, include non-running ones.
# since – Show only containers created since Id, include non-running ones.
# before – Show only containers created before Id, include non-running ones.
# size – 1/True/true or 0/False/false, Show the containers sizes


# filters - a JSON encoded value of the filters (a map[string][]string) to process on the containers list. Available filters:
# exited=<int>; – containers with exit code of <int> ;
# status=(created|restarting|running|paused|exited)
# label=key or label="key=value" of a container label
