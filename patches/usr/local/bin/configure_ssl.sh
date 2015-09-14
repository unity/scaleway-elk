#!/bin/bash

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/nginx.crt -o ! -f /etc/nginx/ssl/nginx.key ];
then
	(echo FR; echo France; echo Paris; echo Scaleway; echo Scaleway Cloud; echo $(/usr/local/bin/oc-metadata --cached PUBLIC_IP_ADDRESS); echo ;) | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt 2>/dev/null >/dev/null
	cat << EOF > /etc/nginx/sites-available/default
server {
    listen 80;

    listen 443 ssl;
    server_name $(/usr/local/bin/oc-metadata --cached PUBLIC_IP_ADDRESS);
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.user;

    location / {
        proxy_pass http://localhost:5601;
        proxy_set_header  X-Real-IP  \$remote_addr;
        proxy_set_header Host \$http_host;
        proxy_set_header X-forwarded-for \$proxy_add_x_forwarded_for;
        port_in_redirect off;
    }
}
EOF
	service nginx restart
fi
