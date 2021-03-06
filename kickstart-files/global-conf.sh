#!/bin/sh
export ADMIN_EMAIL="noverb14@student.aau.dk"
export MASTER_SERVER="kube-master00"
export ETCD_SERVER="$MASTER_SERVER"
export COCKPIT_SERVER="$MASTER_SERVER"
export DNS_SERVER="10.254.3.100"
export TRAEFIK_NODE="kube-node00"
export TRAEFIK_IP="172.19.0.233"
export TRAEFIK_IP_PUB="192.38.56.37"
export CERT_DIR="/srv/kubernetes"
export SERVICE_ACCOUNT_KEY="${CERT_DIR}/service-account.key"
