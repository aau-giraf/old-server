#!/bin/sh
TEMPLATE_DIR="$PWD/templates"
INSTANCE_DIR="$PWD/instances"
USER_DIR="$PWD/users"
KS_OUT_DIR="$PWD/tmp/ks"

USERS=$(ls $USER_DIR)
INSTANCE_IDS=$(ls $INSTANCE_DIR)

SUB_VARS='$IP:$DISTRO:$NETMASK:$GATEWAY:$NAMESERVERS:$HOSTNAME'

# Make kickstart output directory
mkdir -p $KS_OUT_DIR

# For each instance
for ID in $INSTANCE_IDS
do
    # Load settings
    . "$INSTANCE_DIR/$ID"
    KS_FILE_IN="$TEMPLATE_DIR/$DISTRO-$TYPE.cfg.in"
    KS_FILE="$KS_OUT_DIR/$DISTRO-$ID.cfg"
    
    # Generate variable settings
    envsubst $SUB_VARS < "$KS_FILE_IN" > "$KS_FILE"

    # Generate user settings
    cat >> $KS_FILE << EOF

#---------------#
# User settings #
#---------------#
EOF

    for USER in $USERS
    do
        echo "user --name=$USER --groups=wheel" >> $KS_FILE
    done

    # Generate post script
    cat >> $KS_FILE << EOF

#-------------#
# Post script #
#-------------#
%post
sed -i 's/PasswordAuthentication yes/#PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo "%wheel  ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
mkdir -m0700 /root/.ssh/
touch /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
EOF
    for USER in $USERS
    do
        echo "mkdir -m0700 /home/$USER/.ssh/" >> $KS_FILE
        echo "cat <<EOF > /home/$USER/.ssh/authorized_keys" >> $KS_FILE
        cat "$USER_DIR/$USER" >> $KS_FILE
        echo "EOF" >> $KS_FILE
        echo "cat <<EOF >> /root/.ssh/authorized_keys" >> $KS_FILE
        cat "$USER_DIR/$USER" >> $KS_FILE
        echo "EOF" >> $KS_FILE
        echo "chmod 0600 /home/$USER/.ssh/authorized_keys" >> $KS_FILE
        echo "chown -R $USER:$USER /home/$USER/.ssh/" >> $KS_FILE
    done

    # Cat ks/$DISTRO-$TYPE.sh to post script
    SCRIPT_FILE="$TEMPLATE_DIR/$DISTRO-$TYPE.sh"
    cat $SCRIPT_FILE >> $KS_FILE
    echo "%end" >> $KS_FILE
done
