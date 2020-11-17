FROM ubuntu AS stage1

RUN apt-get update && apt-get install -y git \
    && cd /root \
    && git clone https://github.com/Harpya/identity-provider.git ./tmp \
    && cd tmp && git checkout master \
    && mkdir -p /root/tmp/app/var \
    && cd ..

FROM harpya/phalcon_xdebug:0.0.1 AS stage2

LABEL AUTHOR="Eduardo Luz <eduardo@eduardo-luz.com>"
LABEL PROJECT="Harpya <https://www.harpya.net>"

WORKDIR /var/www/html

ARG CACHEBUST=1

COPY --from=stage1 /root/tmp/app/ /var/www/html/
# COPY ./sample-application-ip/app/vendor/harpya /srv/app/lib
COPY startup.sh /root

RUN rm -rf /var/www/html/.env

# RUN ls -la /srv/app/lib/sdk

RUN docker-php-ext-install sockets

RUN cd /root \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \ 
    && chmod +x /usr/bin/composer

RUN cd /root \
    && chmod +x startup.sh \
    && cd /var/www/html \
    && composer update \ 
    && chmod -R 777 /var/www/html/var



CMD [ "/root/startup.sh" ]