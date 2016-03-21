#!/bin/bash

if [ ! -f /etc/nginx/htpasswd.user ]; then
  password=$(pwgen 42)
  echo $password > /root/.kibana.passwd
  htpasswd -cb /etc/nginx/htpasswd.user kibana $password
fi
