#!/bin/bash

set -ex

# reset controller in /etc/hosts
echo "$(sed 's/[0-9\.]\+[\t  ]\+controller/127.0.0.1 controller/g' /etc/hosts)" > /etc/hosts

# mysql
systemctl enable mariadb.service
systemctl start mariadb.service

# rabbitmq
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
rabbitmqctl add_user openstack RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# horizon
sed -i "s/ALLOWED_HOSTS.*/ALLOWED_HOSTS = ['*', ]/g" /etc/openstack-dashboard/local_settings
sed -i "s/OPENSTACK_HOST.*/OPENSTACK_HOST = 'controller'/g" /etc/openstack-dashboard/local_settings
sed -i "s/OPENSTACK_KEYSTONE_URL.*/OPENSTACK_KEYSTONE_URL = 'http:\/\/%s:5000\/v3' % OPENSTACK_HOST/g" /etc/openstack-dashboard/local_settings

# Keystone
mysql -u root --password='' -e "CREATE DATABASE keystone;"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'KEYSTONE_DBPASS';"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'KEYSTONE_DBPASS';"

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
--bootstrap-admin-url http://controller:5000/v3/ \
--bootstrap-internal-url http://controller:5000/v3/ \
--bootstrap-public-url http://controller:5000/v3/ \
--bootstrap-region-id RegionOne

systemctl enable httpd.service
systemctl start httpd.service

source /root/admin-openrc
openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" myproject

# Nova
mysql -u root --password='' -e "CREATE DATABASE nova_api;CREATE DATABASE nova;CREATE DATABASE nova_cell0;"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';"
mysql -u root --password='' -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';"

openstack user create --domain default --password NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

systemctl enable openstack-nova-api.service openstack-nova-conductor.service libvirtd.service openstack-nova-compute.service
systemctl start openstack-nova-api.service openstack-nova-conductor.service libvirtd.service openstack-nova-compute.service
