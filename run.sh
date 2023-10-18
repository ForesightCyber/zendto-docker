#!/bin/sh

. /etc/profile

case $1 in

listusers|deleteuser|setpassword|adduser)
  cmnd=$1
  shift
  /opt/zendto/bin/$cmnd /opt/zendto/config/preferences.php $* 
  ;;

upgrade)
  shift
  /opt/zendto/bin/upgrade $*
  ;;
  
init-config)
  if ! [ -f /opt/zendto/config/preferences.php ]; then
    cp -v /opt/zendto/config.orig/* /opt/zendto/config/
    cp -v /opt/zendto/templates.orig/* /opt/zendto/templates/
  else
    echo "There is already configuration in place. Will not overwrite! Exiting."
    echo "Did you mount /opt/zendto/config outside of docker image?"
    exit 3
  fi
  ;;

^$|run)
  sed -i "s#_TIMEZONE_#${TIMEZONE}#" /etc/php/8.2/apache2/conf.d/30-zendto.ini
  sed -i "s#_MAX_POST_SIZE_#${MAX_POST_SIZE}#" /etc/php/8.2/apache2/conf.d/30-zendto.ini
  cat /etc/php/8.2/apache2/conf.d/30-zendto.ini
  mkdir -p /var/zendto/tmp
  chown -R www-data /var/zendto
  /usr/sbin/cron -f -L7 &
  rm -f /var/run/apache2/*pid
  tail -f /var/log/zendto/zendto.log /var/log/apache2/error.log &
  apache2ctl -D FOREGROUND
  ;;
  
sh|bash)
  bash
  ;;

*)
  echo "Incorrect command $*"
  echo "Enter correct command: init-config|listusers|deleteuser|setpassword|adduser|upgrade|run|sh"
  exit 2
  ;;
esac

