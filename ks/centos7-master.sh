cat << EOF >> /etc/etcd/etcd.conf
ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ADVERTISE_CLIENT_URLS="http://localhost:2379"
EOF
cat << EOF >> /etc/kubernetes/config
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=4"
KUBE_ALLOW_PRIV="--allow-privileged=true"
KUBE_MASTER="--master=http://127.0.0.1:8080"
EOF
cat << EOF >> /etc/kubernetes/apiserver
KUBE_API_ADDRESS="--address=0.0.0.0"
KUBE_API_PORT="--port=8080"
KUBELET_PORT="--kubelet_port=10250"
KUBE_ETCD_SERVERS="--etcd_servers=http://127.0.0.1:2379"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota"
KUBE_API_ARGS=""
EOF
cat << EOF >> /etc/sysconfig/flanneld 
FLANNEL_ETCD="http://master00:2379"
FLANNEL_ETCD_KEY="/flannel/network/"
EOF
etcdctl mk /flannel/network/config '{"Network":"172.17.0.0/16"}'
