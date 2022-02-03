#!/bin/sh

. /etc/profile

/opt/zendto/bin/upgrade
mkdir /var/zendto/tmp
chown -R www-data /var/zendto

/usr/sbin/cron
rm -f /var/run/apache2/*pid
apache2ctl -D FOREGROUND
