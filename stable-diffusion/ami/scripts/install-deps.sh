#!/bin/bash

echo "-- INSTALL AWS LINUX EXTRAS"
sudo yum install amazon-linux-extras -y

echo "-- UPDATE INSTALLED PACKAGES --"
sudo yum update

echo "-- INSTALL PYTHON --"
sudo yum install python3.8 -y

echo "-- INSTALL MINICONDA --"
sudo wget 

# NODE
echo "-- INSTALL NODEJS --"
sudo yum install -y openssl-devel
sudo curl --silent --location https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs