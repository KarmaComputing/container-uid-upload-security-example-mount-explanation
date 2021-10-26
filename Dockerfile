FROM php:7.4-apache

COPY src/ /var/www/html/

RUN mkdir /var/www/html/uploads
RUN chown -R www-data:www-data /var/www/html/uploads

