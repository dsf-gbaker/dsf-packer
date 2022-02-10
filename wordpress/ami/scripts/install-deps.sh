#!/bin/bash
##############################################
# NOTE:
#   We are NOT configuring your wordpress
#   instance here. You'll want to do that
#   in your setup scripts (user_data) when
#   launching an instance based on this AMI
#
#   We are also NOT providing space for the
#   data. We recommend attaching an EBS to
#   your instance and setting up WP to
#   use the attached volume for data storage
#
#   Make sure the wordpress user has perms
#   on that volume!
##############################################
echo "-- INSTALL AWS LINUX EXTRAS"
sudo yum install amazon-linux-extras -y

echo "-- INSTALL PHP --"
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear php-pecl-imagick -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y

echo "-- INSTALL APACHE --"
sudo yum install httpd -y

echo "-- INSTALL WORDPRESS --"
wget https://wordpress.org/wordpress-5.9.tar.gz
tar -xzf wordpress-5.9.tar.gz

# move to our ec2-user home
cd /home/ec2-user
sudo cp -r wordpress/* /var/www/html/