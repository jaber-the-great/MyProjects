iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 22 -j ACCEPT
sudo netstat -ntlp | grep LISTEN
ufw allow 161,162/udp
ufw allow 2380/tcp
ufw allow 4000/tcp
ufw show added
