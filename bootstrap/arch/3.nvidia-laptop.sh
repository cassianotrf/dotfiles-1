#!/bin/bash
sudo pacman -Syu
sudo pacman -S bumbleblee bbswitch xf86-video-intel
sudo gpasswd -a $USER bumblebee
sudo systemctl enable bumblebee.service
