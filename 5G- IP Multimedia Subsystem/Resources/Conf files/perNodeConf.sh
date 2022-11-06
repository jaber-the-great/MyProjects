IPADD="$(hostname -I | awk '{print $2}')"
echo $IPADD
mkdir /etc/clearwater
echo "local_ip=$IPADD
public_ip=$IPADD
public_hostname=$IPADD
etcd_cluster=\"192.168.0.102,192.168.0.103,192.168.0.105,192.168.0.106,192.168.0.107,192.168.0.108\"" > /etc/clearwater/local_config
cat /etc/clearwater/local_config
