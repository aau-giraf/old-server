#!/bin/sh
WORK_DIR="$PWD"
TEMPLATE_DIR="$WORK_DIR/templates"
INSTANCE_DIR="$WORK_DIR/instances"
USER_DIR="$WORK_DIR/users"
TMP_DIR="$WORK_DIR/tmp"
KS_OUT_DIR="$TMP_DIR/ks"

HOSTS_FILE="$TMP_DIR/hosts"

USERS=$(ls $USER_DIR)
INSTANCE_IDS=$(ls $INSTANCE_DIR)

SUB_VARS_KS='$IP:$DISTRO:$NETMASK:$GATEWAY:$NAMESERVERS:$HOSTNAME'
SUB_VARS_SCRIPT='$ADMIN_EMAIL:$MASTER_SERVER:$ETCD_SERVER:$COCKPIT_SERVER:$SERVICE_ACCOUNT_KEY:$SSL_DIR:$IP:$TRAEFIK_NODE'

# Load global configuration
. $WORK_DIR/global-conf.sh

# Make kickstart output directory
mkdir -p $KS_OUT_DIR

# Generate /etc/hosts
echo -n "" > $HOSTS_FILE
for ID in $INSTANCE_IDS
do
    . "$INSTANCE_DIR/$ID"
    echo "$IP $HOSTNAME" >> "$TMP_DIR/hosts"
done

# For each instance
for ID in $INSTANCE_IDS
do
    # Load settings
    . "$INSTANCE_DIR/$ID"
    KS_FILE_IN="$TEMPLATE_DIR/$DISTRO-$TYPE.cfg.in"
    KS_FILE="$KS_OUT_DIR/$DISTRO-$ID.cfg"
    SCRIPT_FILE_IN="$TEMPLATE_DIR/$DISTRO-$TYPE.sh.in"
    SCRIPT_FILE="$TMP_DIR/$DISTRO-$TYPE.sh"
    
    # Generate variable settings
    envsubst $SUB_VARS_KS < "$KS_FILE_IN" > "$KS_FILE"
    envsubst $SUB_VARS_SCRIPT < "$SCRIPT_FILE_IN" > "$SCRIPT_FILE"

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

    # Generate /etc/hosts
    echo "cat <<EOF >> /etc/hosts" >> $KS_FILE
    echo "127.0.0.1 $HOSTNAME" >> $KS_FILE
    cat "$TMP_DIR/hosts" >> $KS_FILE
    echo "EOF" >> $KS_FILE

    # Setup public ssh keys
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
    cat $SCRIPT_FILE >> $KS_FILE
    echo "%end" >> $KS_FILE
done
