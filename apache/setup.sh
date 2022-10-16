#!/usr/bin/env bash

if [ "${USE_BASIC_AUTH}" = "true" ]; then \
    echo "use basic auth"; 
    cp /etc/basicauth.htaccess /var/www/html/.htaccess; \
else 
    echo "WARNING!! not use basic auth";
fi

if [ "${USE_PRD_PHP_INI}" = "true" ]; then \
    echo "use production php.ini"; 
    echo "$PHP_INI_DIR/php.ini";
    cp /etc/production.php.ini "$PHP_INI_DIR/php.ini"; \
else 
    echo "WARNING!! not use production php.ini";
fi

exec "$@"