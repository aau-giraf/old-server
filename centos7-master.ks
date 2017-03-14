install

# Accept Eula
eula --agreed

# Locale
keyboard 'dk'
lang en_US
timezone Europe/Copenhagen

# Security settings
auth  --useshadow  --passalgo=sha512
firewall --disabled
selinux --enforcing

# Installation settings
reboot
cdrom
graphical
firstboot --disable
bootloader --location=mbr
clearpart --all

# System settings
repo --name="EPEL" --baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64
%packages
@base
@core
yum-cron
vim
%end
services --enabled=NetworkManager,sshd

# Network settings
network --bootproto=dhcp --device=eno16780032 --activate
network --hostname=master.giraf.cs.aau.dk
