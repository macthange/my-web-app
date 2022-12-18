#!/bin/bash
sudo yum -y update
sudo yum install -y httpd
sudo chkconfig httpd on
sudo /etc/init.d/httpd start