# Informations
Script for Wazo, deploy a new Host in Nginx When run Certbot

# Installation
```shell
wget https://raw.githubusercontent.com/fouille/certbot_deploy_new_vhost/main/install.sh
chmod +x install.sh
```
# Basic run
```shell
./install.sh -d my.domain.tld
```
# Options
```shell
usage : ./install.sh {-t|-d|-c|-r domain}
    without arg (tdcr)  : can't run
    -d domain          : install mode Wazo, with custom vHost and Certbot (ex.: domain.tld or my.domain.tld)
    -t domain          : try to use Certbot (staging environment mode)
    -c domain          : just use Certbot manual mode (production mode)
    -r domain          : remove files with your domain already created (don't revoke Certbot's certificates)
```
