#!/bin/sh

yum install -y http://rdo.fedorapeople.org/openstack/openstack-havana/rdo-release-havana.rpm  
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/epel.repo
yum install -y openstack-packstack nagios nagios-plugins-all nagios-plugins-nrpe nrpe

packstack --answer-file packstack-answers-vlan.txt
