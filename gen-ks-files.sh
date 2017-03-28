#!/bin/sh

DISTRO="centos7"
SUB_VARS='$IP:$NETMASK:$GATEWAY:$NAMESERVERS:$HOSTNAME'
KS_IN_DIR="$(pwd)/ks"
KS_OUT_DIR="$(pwd)/tmp/ks"

USERS=$(ls users)

MASTER_IDS=$(ls masters)
NODE_IDS=$(ls nodes)
SERVER_IDS="$MASTER_IDS $NODE_IDS"

# Substitude variables
mkdir -p $KS_OUT_DIR
for ID in $MASTER_IDS
do
    . "masters/$ID"
    KS_FILE_IN="$KS_IN_DIR/$DISTRO-master.cfg.in"
    KS_FILE_OUT="$KS_OUT_DIR/$DISTRO-$ID.cfg"
    envsubst $SUB_VARS < "$KS_FILE_IN" > "$KS_FILE_OUT"
done
for ID in $NODE_IDS
do
    . "nodes/$ID"
    KS_FILE_IN="$KS_IN_DIR/$DISTRO-node.cfg.in"
    KS_FILE_OUT="$KS_OUT_DIR/$DISTRO-$ID.cfg"
    envsubst $SUB_VARS < "$KS_FILE_IN" > "$KS_FILE_OUT"
done

# Generate settings
for ID in $SERVER_IDS
do
    KS_FILE=$KS_OUT_DIR/$DISTRO-$ID.cfg

    echo "" >> $KS_FILE
    echo "#---------------#" >> $KS_FILE
    echo "# User settings #" >> $KS_FILE
    echo "#---------------#" >> $KS_FILE
    for USER in $USERS
    do
        echo "user --name=$USER" >> $KS_FILE
    done

    # Generate post script
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
        cat "users/$USER" >> $KS_FILE
        echo "EOF" >> $KS_FILE
        echo "cat <<EOF >> /root/.ssh/authorized_keys" >> $KS_FILE
        cat "users/$USER" >> $KS_FILE
        echo "EOF" >> $KS_FILE
        echo "chmod 0600 /home/$USER/.ssh/authorized_keys" >> $KS_FILE
        echo "chown -R $USER:$USER /home/$USER/.ssh/" >> $KS_FILE
    done
    echo "%end" >> $KS_FILE
done
