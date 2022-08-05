#!/bin/bash

echo "#### Set template ####"
mkdir /var/cache/certbot_tmp
#wget in dir
cat > /var/cache/certbot_tmp/certbot_template <<'EOF'
sed 's/domain/$1/'
EOF

echo ""
echo "#### Copy template to NGINX ####"
cp /var/cache/certbot_tmp/certbot_template /etc/nginx/sites-available/$1

echo ""
echo "#### Activate Nginx Certbot vHost ####"
ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/

echo ""
echo "#### Run Certbot ####"

