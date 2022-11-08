Description: a docker machine with oracle and php 7.4 configured.

OS: UBUNTU 18.04

PHP VERSION: 7.4

ORACLE LIB: 12.1

PDO DRIVERS: PDO_OCI

docker run -p 80:80 -v DIRECTORY_HOST:/var/www/html mesompi2/apache-php7.4-oracle
