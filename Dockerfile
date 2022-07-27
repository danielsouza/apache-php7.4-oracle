FROM ubuntu:18.04

USER root

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update

ENV TZ=America/Porto_Velho
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Install Apache2 / PHP 7.4 & Co.
RUN apt-get -y install apache2
RUN apt-get -y install php7.4 libapache2-mod-php7.4 curl libaio1 php7.4-dev php7.4-xml git

# Install the Oracle Instant Client
ADD oracle/* /tmp/
ADD php/php-7.4.30.tar.bz2 /root/

RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb

# # Install PDO_OCI
# RUN cd ~  \
# && tar -jxvf php-7.4.30.tar.bz2 \
# && cp -r php-7.4.30/ext/pdo_oci /tmp/ \
# && cd /tmp/pdo_oci/ \
# && phpize \
# && ./configure --with-pdo-oci=instantclient,/usr/lib/oracle/12.1/client64/lib,12.1 \
# && make \
# && make install \
# && echo 'extension=pdo_oci.so' > /etc/php/7.4/mods-available/pdo_oci.ini \
# && ln -s /etc/php/7.4/mods-available/pdo_oci.ini /etc/php/7.4/apache2/conf.d/20-pdo_oci.ini

# Set up the Oracle environment variables
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib/
ENV ORACLE_HOME ${LD_LIBRARY_PATH}
ENV TNS_ADMIN ${LD_LIBRARY_PATH}

# Install the OCI8 PHP extension
RUN echo 'instantclient,/usr/lib/oracle/12.1/client64/lib' | pecl install -f oci8-2.2.0
RUN echo "extension=oci8.so" > /etc/php/7.4/apache2/conf.d/30-oci8.ini

# Set up the Apache2 environment variables
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

EXPOSE 80

# Remove installation files
#RUN rm -rf /root/* \
#&& rm -rf /tmp/* 

# Run Apache2 in Foreground
CMD /usr/sbin/apache2 -D FOREGROUND