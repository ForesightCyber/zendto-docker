#!/bin/sh

. /etc/profile

/opt/zendto/bin/upgrade

/usr/sbin/cron
rm -f /var/run/apache2/*pid
apache2ctl -D FOREGROUND
