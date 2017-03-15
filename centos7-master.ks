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
text
zerombr
firstboot --disable
bootloader --location=mbr

# Partition settings
clearpart --all --initlabel
part pv.01 --fstype="lvmpv" --ondisk=sda --size=20480
part pv.02 --fstype="lvmpv" --ondisk=sdb --size=102400
part pv.03 --fstype="lvmpv" --ondisk=sdc --size=25600
part /boot --fstype="xfs" --ondisk=sda --size=500
volgroup centos --pesize=4096 pv.01 pv.02 pv.03
logvol /  --fstype="xfs" --grow --maxsize=102400 --size=1024 --name=root --vgname=centos
logvol swap  --fstype="swap" --size=2048 --name=swap01 --vgname=centos

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
network --bootproto=dhcp --device=ens160 --activate
network --hostname=master.giraf.cs.aau.dk
