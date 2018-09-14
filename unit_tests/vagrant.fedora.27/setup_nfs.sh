#!/bin/sh

sudo echo "/home/vagrant *(rw,sync,all_squash,anonuid=1000,anongid=1000)" > /etc/exports

sudo service nfs start
sudo systemctl enable nfs
