#!/bin/sh

DISTRO="centos7"
SUB_VARS='$IP:$NETMASK:$GATEWAY:$NAMESERVERS:$HOSTNAME'
KS_IN_DIR="$(pwd)/ks"
KS_OUT_DIR="$(pwd)/tmp/ks"

USERS=$(ls users)
SERVER_IDS=$(ls servers)

# Make kickstart output directory
mkdir -p $KS_OUT_DIR

for ID in $SERVER_IDS
do
    # Load settings
    . "servers/$ID"
    KS_FILE_IN="$KS_IN_DIR/$DISTRO-$TYPE.cfg.in"
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
        echo "user --name=$USER" >> $KS_FILE
    done

    # Generate post script
    cat >> $KS_FILE << EOF

#-------------#
# Post script #
#-------------#
%post
mkdir -m0700 /root/.ssh/
touch /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
EOF
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

    # Cat ks/$DISTRO-$TYPE.sh to post script
    SCRIPT_FILE="$KS_IN_DIR/$DISTRO-$TYPE.sh"
    cat $SCRIPT_FILE >> $KS_FILE
    echo "%end" >> $KS_FILE
done
