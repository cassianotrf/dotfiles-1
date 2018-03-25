#!/bin/bash

# # load the correct keymap
# loadkeys us-acentos

# # set time and date
# timedatectl set-ntp true

# # partitions ##### EXTRA CAREFUL ######
# 
# mkfs.fat -F32 /dev/nvme0n1p1
# mkfs.ext4 /dev/nvme0n1p2
# mkswap /dev/nvme0n1p3
# swapon /dev/nvme0n1p3

# # mount 
# mount /dev/nvme0n1p2 /mnt
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot

# # pacstrap
# curl -o /etc/pacman.d/mirrorgen "https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
# sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorgen
# rankmirrors -n 6 /etc/pacman.d/mirrorgen > /etc/pacman.d/mirrorlist
# pacstrap /mnt base base-devel

# # fstab
# genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt