echo "nameserver 192.168.0.113" > /etc/dnsmasq.resolv.conf
echo "RESOLV_CONF=/etc/dnsmasq.resolv.conf" >> /etc/default/dnsmasq
service dnsmasq restart
