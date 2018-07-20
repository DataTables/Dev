#!/bin/bash

pkill -U $(id -u) ssh-agent
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

vagrant destroy -f
vagrant up

