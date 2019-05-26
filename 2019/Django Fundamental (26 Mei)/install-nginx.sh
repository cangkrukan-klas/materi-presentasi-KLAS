#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [[ ! -f $1 ]]; then
   echo "Nginx configuration cannot be found"
   exit 1
fi

if [[ "$#" -ne 2 ]]; then
   echo "usage: $0 <nginx_conf> <host_ip>"
   exit 1
fi

echo "========Installing Nginx========"
apt install -y nginx
echo "========Setting up firewall========"
ufw allow 'Nginx Full'
echo "========Enable services========"
systemctl enable nginx
echo "========Starting service========"
systemctl start nginx
echo "========Configuring Nginx Proxy to Django Dev Server========"
sed -i "s|host-ip|$2|" $1
cp $1 /etc/nginx/sites-available/
ln -s /etc/nginx/sites-enabled/ /etc/nginx/sites-available/$1
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
echo "========Success========"
