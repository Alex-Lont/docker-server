#!/bin/bash
nmcli con add type vlan con-name VLAN10 dev eth0 id 10
nmcli con mod VLAN10 ipv4.address 192.168.10.11/24
nmcli con mod VLAN10 ipv4.gateway 192.168.10.1
nmcli con mod VLAN10 ipv4.dns 127.0.0.1
nmcli con up VLAN10
nmcli con add type vlan con-name VLAN14 dev eth0 id 14
nmcli con mod VLAN14 ipv4.address 10.0.14.11/28
nmcli con mod VLAN14 ipv4.gateway 10.0.14.1
nmcli con mod VLAN14 ipv4.dns 127.0.0.1
nmcli con up VLAN14
nmcli con add type vlan con-name VLAN20 dev eth0 id 20
nmcli con mod VLAN20 ipv4.address 10.0.20.11/28
nmcli con mod VLAN20 ipv4.gateway 10.0.20.1
nmcli con mod VLAN20 ipv4.dns 127.0.0.1
nmcli con up VLAN20
nmcli con up VLAN30
nmcli con add type vlan con-name VLAN30 dev eth0 id 30
nmcli con mod VLAN30 ipv4.address 172.16.30.1/26
nmcli con mod VLAN30 ipv4.gateway 172.16.30.1
nmcli con mod VLAN30 ipv4.dns 127.0.0.1
nmcli con up VLAN30