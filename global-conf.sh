#!/bin/sh
export ADMIN_EMAIL="noverb14@student.aau.dk"
export MASTER_SERVER="kube-master00"
export ETCD_SERVER="$MASTER_SERVER"
export COCKPIT_SERVER="$MASTER_SERVER"
export DNS_SERVER="10.254.3.100"
export TRAEFIK_NODE="kube-node00"
export SERVICE_ACCOUNT_KEY="/etc/kubernetes/service-account.key"
export SSL_DIR="/srv/kubernetes"
