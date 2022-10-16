FROM php:7.4-apache
EXPOSE 8080

ADD ./apache/ports.conf /etc/apache2
# ADD ./apache/basicauth.htaccess /etc/basicauth.htaccess
ADD ./apache/000-default.conf /etc/apache2/sites-available
ADD ./php/php.ini /etc/production.php.ini
RUN echo "ServerName test" | tee /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn

# 開發時はphp.iniをデフォルトのままにする
# ADD ./php/php.ini "$PHP_INI_DIR/php.ini"

# Dockerfileとの差分箇所
RUN \
    if [ ! -f /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so ]; then \
        pecl install xdebug; \
        ls -l /usr/local/lib/php/extensions; \
    fi; \
    { \
        echo 'zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so'; \
        echo '[xdebug]'; \
        echo 'xdebug.remote_enable=1'; \
        echo 'xdebug.remote_autostart=1'; \
        echo 'xdebug.remote_host=host.docker.internal'; \
        echo 'xdebug.remote_port=9003'; \
        echo 'xdebug.client_port=9003'; \
        echo 'xdebug.client_host=host.docker.internal'; \
        echo 'xdebug.mode=debug'; \
    } > /usr/local/etc/php/conf.d/php-xdebug.ini ;
# Dockerfileとの差分箇所 ここまで

# RUN apt-get update && apt-get install -y net-tools wget && \
#     wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy && \
#     chmod +x /usr/local/bin/cloud_sql_proxy
    
COPY ./apache/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

COPY --chown=www-data:www-data src /var/www/html

RUN chmod 755 /var/www/html
# RUN chmod 640 /var/www/html/wp-config.php

ENTRYPOINT ["setup.sh"]
CMD ["apache2-foreground"]