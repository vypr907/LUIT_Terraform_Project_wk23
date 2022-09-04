#!/bin/bash

yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
instAZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
echo -e "<head><style>body {background-image: url("https://free4kwallpapers.com/uploads/originals/2020/05/06/-halo-infinite-wallpaper.jpg");background-repeat: no-repeat;background-attachment: fixed;background-size: cover;}p {color: #32a852;}</style></head><body><center><h1><p>Welcome to vyprTECH HQ! This is $(hostname -f) We are currently in Availability Zone: AZID</p></h1><img src="https://live.staticflickr.com/65535/52204755191_eeb61d5ccd_o_d.png" alt="programmer avatar" width="200" height="350"></center></body>" >> /var/www/html/index.txt
sed "s/AZID/$instAZ/" /var/www/html/index.txt > /var/www/html/index.html