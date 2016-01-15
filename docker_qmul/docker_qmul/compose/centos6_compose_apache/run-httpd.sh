#!/bin/bash

#~# Script to remove old PIDs and start-up Apache in the foreground

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/*

exec /usr/sbin/apachectl -DFOREGROUND

