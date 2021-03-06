#!/bin/bash

# load the correct keymap
loadkeys br-abnt2

# set time and date
timedatectl set-ntp true

echo "danger ZONE "
echo "vmware || hyper-v || physical? "

read mtype
if [ $mtype == "vmware" ]
then
  # partitions ##### EXTRA CAREFUL ######
  # vmware settings
  mkfs.ext4 /dev/sda1
  mount /dev/sda1 /mnt
elif [ $mtype == "sda" ]
then
	mkfs.fat -F32 /dev/sda1
	mkfs.ext4 /dev/sda2
	mkswap /dev/sda3
	swapon /dev/sda3
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
elif [ $mtype == "nvme" ]
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
curl -o /etc/pacman.d/mirrorlist "https://raw.githubusercontent.com/rafamoreira/dotfiles/master/bootstrap/arch/sys-install/mirrorlist"
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

cd /mnt/root
wget https://raw.githubusercontent.com/rafamoreira/dotfiles/master/bootstrap/arch/sys-install/2.post-chroot-install.sh 2.post-chroot-install.sh
chmod +x /mnt/root/2.post-chroot-install.sh
wget https://raw.githubusercontent.com/rafamoreira/dotfiles/master/bootstrap/arch/sys-install/3.first-boot-install.sh 3.first-boot-install.sh
chmod +x /mnt/root/3.first-boot-install.sh

arch-chroot /mnt
