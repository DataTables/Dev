#!/bin/bash
# Usage: no args runs VM once, or the arg is the sleep interval between continuous iterations

pkill -U $(id -u) ssh-agent
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

vagrant destroy -f
vagrant up
