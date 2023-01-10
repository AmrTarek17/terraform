#!/bin/bash
    sudo su
    apt update -y
    apt install nginx -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello World! - Amr Tarek-${HOSTNAME}</h1>" > /var/www/html/*.html
    systemctl restart nginx