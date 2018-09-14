#!/bin/sh
######
# Personal stuff for Colin

# Env
echo "set ic" >> ~/.exrc
echo "set ai" >> ~/.exrc
echo "set ts=2" >> ~/.exrc
echo "set sw=2" >> ~/.exrc
echo "alias vi='vim'" >> ~/.bashrc
echo "alias la='ls -a'" >> ~/.bashrc

# Apps
sudo dnf upgrade -y vim-minimal
sudo dnf install -y vim-enhanced
sudo dnf install -y vim
