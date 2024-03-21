#!/bin/bash

NGINX_CONF="/etc/nginx/nginx.conf"
PATTERN="include /etc/nginx/conf.d/*.conf;"
INSERT_LINE="include /etc/nginx/sites-enabled/*;"

grep -qF -- "$INSERT_LINE" "$NGINX_CONF" || {
	awk -v pat="$PATTERN" -v insert_line="$INSERT_LINE" '
  $0 - pat {
  print $0
  print insert_line
  next
}
{ print } ' "$NGINX_CONF" >tmpfile && sudo mv tmpfile "$NGINX_CONF"
}

sudo systemctl reload nginx
