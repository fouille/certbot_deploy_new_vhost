#!/bin/bash

install_template () {
    echo "#### 1/5 Set template ####"
    mkdir /var/cache/certbot_tmp
    wget -q -O /var/cache/certbot_tmp/$domain https://raw.githubusercontent.com/fouille/certbot_deploy_new_vhost/main/template/certbot_template
    sed -i 's/domain/'$domain'/g' /var/cache/certbot_tmp/$domain

    echo ""
    echo "#### 2/5 Copy template to NGINX ####"
    cp /var/cache/certbot_tmp/$domain /etc/nginx/sites-available/

    echo ""
    echo "#### 3/5 Activate Nginx Certbot vHost ####"
    ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/

    echo ""
    echo "#### 4/5 Reload NGinx ####"
    systemctl reload nginx

    echo ""
    echo "#### 5/5 Run Certbot ####"
    certbot --redirect --nginx -d $domain
}

run_certbot_manual () {
    echo ""
    echo "#### Run Certbot ####"
    echo "###########################################################"
    echo "#### THIS CONFIGURATION MAYBE AFFECT NEXT WAZO UPGRADE ####"
    echo "###########################################################"
    echo ""
    certbot --nginx -d $domain
}

run_certbot_try () {
certbot certonly --redirect --dry-run --nginx -d $domain
}

remove_files () {
    echo "#### 1/3 RUN $remove_file Remove ####"
    echo ""
    echo "#### 2/3 UNLINK $remove_file from NGinx ####"
    unlink /etc/nginx/sites-enabled/$remove_file

    echo "#### 3/3 REMOVE $remove_file from directories ####"
    rm /etc/nginx/sites-available/$remove_file
    rm /var/cache/certbot_tmp/$remove_file
    rmdir /var/cache/certbot_tmp

    echo ""
    echo "#### Remove Completed ####"
}

usage() {
    cat << EOF
    This script is used to install Wazo

    usage : $(basename $0) {-t|-d|-c|-r domain}
        without arg (tdcr)  : can't run
        -d domain          : install mode Wazo, with custom vHost and Certbot (ex.: domain.tld or my.domain.tld)
        -t domain          : try to use Certbot (staging environment mode)
        -c domain          : just use Certbot manual mode (production mode)
        -r domain          : remove files with your domain already created (don't revoke Certbot's certificates) 
EOF
    exit 1
}

while getopts ':t:d:c:r:' opt; do
    case ${opt} in
        t)
            domain=$OPTARG
            run_certbot_try
            ;;
        d)
            domain=$OPTARG
            install_template
            ;;
        c)
            domain=$OPTARG
            run_certbot_manual
            ;;
        r)
            remove_file=$OPTARG
            remove_files
            ;;
        *)
            usage
            ;;
    esac
done
