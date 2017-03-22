#!/bin/sh

USERS=$(ls pub-ssh-keys/)
SERVERS="master"
DISTRO="centos7"

# Generate settings
for SERVER in $SERVERS
do
    KS_FILE=$DISTRO-$SERVER.cfg
    cp $KS_FILE.in $KS_FILE

    echo "" >> $KS_FILE
    echo "#---------------#" >> $KS_FILE
    echo "# User settings #" >> $KS_FILE
    echo "#---------------#" >> $KS_FILE
    for USER in $USERS
    do
        echo "user --name=$USER" >> $KS_FILE
    done
done

# Generate post script
for SERVER in $SERVERS
do
    KS_FILE=$DISTRO-$SERVER.cfg

    echo "" >> $KS_FILE
    echo "#-------------#" >> $KS_FILE
    echo "# Post script #" >> $KS_FILE
    echo "#-------------#" >> $KS_FILE
    echo "%post" >> $KS_FILE
    echo "mkdir -m0700 /root/.ssh/" >> $KS_FILE
    echo "touch /root/.ssh/authorized_keys" >> $KS_FILE
    echo "chmod 0600 /root/.ssh/authorized_keys" >> $KS_FILE
    for USER in $USERS
    do
        echo "mkdir -m0700 /home/$USER/.ssh/" >> $KS_FILE
        echo "cat <<EOF > /home/$USER/.ssh/authorized_keys" >> $KS_FILE
        cat pub-ssh-keys/$USER >> $KS_FILE
        echo "EOF" >> $KS_FILE
        echo "cat <<EOF >> /root/.ssh/authorized_keys" >> $KS_FILE
        cat pub-ssh-keys/$USER >> $KS_FILE
        echo "EOF" >> $KS_FILE
        echo "chmod 0600 /home/$USER/.ssh/authorized_keys" >> $KS_FILE
        echo "chown -R $USER:$USER /home/$USER/.ssh/" >> $KS_FILE
    done
    echo "%end" >> $KS_FILE
done
