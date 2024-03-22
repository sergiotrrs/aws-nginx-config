#!/bin/bash

NGINX_CONF="/etc/nginx/nginx.conf"
PATTERN="include /etc/nginx/conf.d/*.conf;"
INSERT_LINE="include /etc/nginx/sites-enabled/*;"

sudo sed -i "/^include \/etc\/nginx\/conf.d\/\*.conf;$/a $INSERT_LINE" "$NGINX_CONF"

if [[ -f "/home/ec2-user/aws-nginx-config/app" ]]; then
	sudo cp "/home/ec2-user/aws-nginx-config/app" /etc/nginx/sites-available/app &&
		sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/ &&
		sudo systemctl start nginx &&
		sudo systemctl reload nginx &&
		sudo cp "/home/ec2-user/aws-nginx-config/app.service" /etc/systemd/system/ &&
		sudo systemctl enable app.service &&
		sudo systemctl restart nginx &&
		sudo systemctl start app &&
		sudo systemctl enable app
else
	echo "Required file /home/ec2-user/aws-nginx-config/app does not exist."
fi
