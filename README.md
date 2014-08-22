openstack-tool
==============

Some useful tools for openstack deployment, deployment and operation. 
The `deploy` directory contains tools for the deployment, while the `devop` one is for development and operation.


#Deploy

The deployment is based on [RDO](openstack.redhat.com).

##Server configuration
* Managment   Network: `192.168.122.0/24`
* Data        Network: `10.0.0.0/24`
* Control Node: `10.0.0.100 (eth0)`, `192.168.122.100 (eth1)`
* Compute Node: `10.0.0.101 (eth0)`, `192.168.122.101 (eth1)`

##rdo_install.sh
Install openstack based on RDO and the configuration template.

##rdo_purge.sh
Clear the machine which has openstack installed.

##demo_init.sh
After the installation, init by adding a user and a project with net/subnet/vm.
Recommend to download the [Cirros Image] (https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img) and put it under the deploy directory.
Otherwise the tool will automatically do it.

##demo_clean.sh
Clean the added user, project, vm, net, subnet, etc. by the demo_init.sh.

##havana
Some configuration files for the havana release.
###packstack-answers-gre
RDO configuration template for multinode, GRE based.

###packstack-answers-vlan
RDO configuration template for multinode, Vlan based.

###keystonerc_admin
A reference keystonrc of the admin role.

##icehouse
Some configuration files for the icehouse release.

#Devop

##bashrc
A bashrc template. Please rename this to `.bashrc`, and put in your home directory.

##bash_aliases
Some useful aliases. Please rename this to `.bash_aliases`, and put in your home directory.

##bash_color
Enable colorful bash if supported. Please rename this to `.bash_color`, and put in your home directory.

##ovs_mon
This script can monitor multiple OpenvSwitch rules by filtering useful ones and reformat them. It even support colorful output!
Just put it in your local PATH such as /usr/local/bin/. A more powerful tool is [easyOVS] (https://github.com/yeasy/easyOVS).

The original way to observe the rules in a switch (e.g., s1) is using ovs-ofctl, while it's hard to explore when there're lots of rules
```
$ sudo ovs-ofctl dump-flows s1
NXST_FLOW reply (xid=0x4):
 cookie=0x0, duration=294.454s, table=0, n_packets=0, n_bytes=0, priority=2400,dl_dst=ff:ff:ff:ff:ff:ff actions=CONTROLLER:65535
 cookie=0x0, duration=294.448s, table=0, n_packets=0, n_bytes=0, priority=801,ip actions=CONTROLLER:65535
 cookie=0x0, duration=294.456s, table=0, n_packets=0, n_bytes=0, priority=2400,arp actions=CONTROLLER:65535
 cookie=0x0, duration=294.455s, table=0, n_packets=4, n_bytes=280, priority=2400,dl_type=0x88cc actions=CONTROLLER:65535
 cookie=0x0, duration=197.693s, table=0, n_packets=0, n_bytes=0, priority=1000,vlan_tci=0x0000,dl_dst=00:00:00:00:00:01 actions=output:1
 cookie=0x0, duration=197.665s, table=0, n_packets=0, n_bytes=0, priority=1000,vlan_tci=0x0000,dl_dst=00:00:00:00:00:02 actions=output:1
 cookie=0x0, duration=294.461s, table=0, n_packets=0, n_bytes=0, priority=1700,ip,dl_dst=fc:3f:03:04:05:b8 actions=CONTROLLER:65535
 cookie=0x0, duration=294.448s, table=0, n_packets=0, n_bytes=0, priority=800 actions=drop
 cookie=0x0, duration=294.454s, table=0, n_packets=0, n_bytes=0, priority=2400,ip,nw_proto=2 actions=CONTROLLER:65535
```
Use ovs_mon, it is easy to watch multiple switches simultaneously, and only output 'useful' rules:
```
$ ovsm s1 s2 s3
###s1
2400     PKT=8    dl_type=0x88cc                                               ACT=CONTROLLER:65535
                                                                               
###s2
2400     PKT=5    dl_type=0x88cc                                               ACT=CONTROLLER:65535
2400     PKT=2    dl_dst=ff::ff                                                ACT=CONTROLLER:65535
2400     PKT=18   arp                                                          ACT=CONTROLLER:65535
1401     PKT=1    ip,dl_src=00::02,nw_src=10.0.0.2                             ACT=CONTROLLER:65535
1401     PKT=1    ip,dl_src=00::01,nw_src=10.0.0.1                             ACT=CONTROLLER:65535
                                                                               
###s3
2400     PKT=5    dl_type=0x88cc                                               ACT=CONTROLLER:65535
```

##ovs_delflow
This tool support specifically del a flow from ovs. The flow can be given with priority and actions, e.g., `priority=100,ip actions=OUTPUT:1`, or `priority=100 ip,nw_proto=2 actions=OUTPUT:2`.

##nss
This script will show all ip address inside each network namespace created inside openstack node.
If give a parameter, then it will show the network namespace containing the key.
```
$ nss 10.0.3.3
qdhcp-40a3b06e-1564-46d1-9429-fc73d9186c8e
99: tapa864b81a-50: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN link/ether fa:16:3e:5b:bf:0d brd ff:ff:ff:ff:ff:ff inet 10.0.3.3/24 brd 10.0.3.255 scope global tapa864b81a-50 inet6 fe80::f816:3eff:fe5b:bf0d/64 scope link valid_lft forever preferred_lft forever 100: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 inet 127.0.0.1/8 scope host lo inet6 ::1/128 scope host valid_lft forever preferred_lft forever
```
