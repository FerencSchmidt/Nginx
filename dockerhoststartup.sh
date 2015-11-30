#!/usr/bin/env bash

sudo -s 

apt-get -y update 
 
#install defaults
apt-get install -y htop \
 	git 

#copy script 
cp /vagrant/manager.sh cmanager.sh

#cleanup
apt-get autoremove -y 
