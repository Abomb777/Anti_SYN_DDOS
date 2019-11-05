echo "20000" > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo "1" > /proc/sys/net/ipv4/tcp_synack_retries
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
echo "15" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "20000" > /proc/sys/net/core/netdev_max_backlog
echo "20000" > /proc/sys/net/core/somaxconn

iptables -N syn_flood
iptables -A INPUT -p tcp --syn -j syn_flood
iptables -A syn_flood -m limit --limit 500/s --limit-burst 2000 -j RETURN
iptables -A syn_flood -j DROP

iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP

iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP

iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP

iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP

iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP


