#!/bin/bash

# load the correct keymap
loadkeys dvorak

# set time and date
timedatectl set-ntp true

echo "danger ZONE "
echo "vmware || physical? "

read mtype
if [ $mtype == "vmware" ]
then
  # partitions ##### EXTRA CAREFUL ######
  # vmware settings
  mkfs.ext4 /dev/sda1
  mount /dev/sda1 /mnt
elif [ $mtype == "hyper-v" ]
then
	mkfs.fat -F32 /dev/sda1
	mkfs.ext4 /dev/sda2
	mkswap /dev/sda3
	swapon /dev/sda3
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
elif [ $mtype == "physical" ]
then
  mkfs.fat -F32 /dev/nvme0n1p1
  mkfs.ext4 /dev/nvme0n1p2
  mkswap /dev/nvme0n1p3
  swapon /dev/nvme0n1p3

  # mount 
  mount /dev/nvme0n1p2 /mnt
  mkdir /mnt/boot
  mount /dev/nvme0n1p1 /mnt/boot
fi


# pacstrap
curl -o /etc/pacman.d/mirrorgen "https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorgen
rankmirrors -n 6 /etc/pacman.d/mirrorgen > /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

cd /mnt/root
wget https://raw.githubusercontent.com/rafamoreira/dotfiles/master/bootstrap/arch/sys-install/post-chroot-install.sh post-chroot-install.sh
chmod +x /mnt/root/post-chroot-install.sh
wgte https://raw.githubusercontent.com/rafamoreira/dotfiles/master/bootstrap/arch/sys-install/first-boot-install.sh first-boot-install.sh
chmod +x /mnt/root/first-boot-install.sh

arch-chroot /mnt
