#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable php8.0 mariadb10.5
sudo yum clean metadata
sudo yum install -y php php-mysqlnd unzip httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start mariadb
sudo systemctl enable mariadb
cd /var/www/html
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo cp -r wordpress/* .
sudo rm -rf wordpress latest.zip
sudo chown -R apache:apache /var/www/html
sudo mysql
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
quit