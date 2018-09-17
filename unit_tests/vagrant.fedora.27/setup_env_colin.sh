#!/bin/sh
######
# Personal stuff for Colin

# Env
echo "set ic" >> ~/.exrc
echo "set ai" >> ~/.exrc
echo "set ts=4" >> ~/.exrc
echo "set sw=4" >> ~/.exrc
echo "alias vi='vim'" >> ~/.bashrc
echo "alias la='ls -a'" >> ~/.bashrc

# Apps
sudo dnf upgrade -y vim-minimal
sudo dnf install -y vim-enhanced
sudo dnf install -y vim
