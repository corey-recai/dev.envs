# 8.3
ARG VERSION
FROM php:${VERSION}-fpm-alpine

# install extensions needed to run wordpress
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql
