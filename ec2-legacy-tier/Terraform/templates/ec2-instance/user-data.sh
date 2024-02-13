#!/bin/bash

sudo yum update -y
sudo yum -y install httpd
sudo service httpd start
sudo mkdir /var/www/html/efs-mount-point
sudo mount -t efs file-system-id:/ /var/www/html/efs-mount-point
sudo mkdir /var/www/html/efs-mount-point/sampledir
sudo chown ec2-user /var/www/html/efs-mount-point/sampledir
sudo chmod -R o+r /var/www/html/efs-mount-point/sampledir
echo "<html><h1>Hello from Amazon EFS</h1></html>" > /var/www/html/efs-mount-point/sampledir/hello.html
