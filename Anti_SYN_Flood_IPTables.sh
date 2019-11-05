#!/bin/bash
IFCONFIG=/sbin/ifconfig
GREP=/bin/grep
AWK=/bin/awk
CUT=/bin/cut
NETSTAT=/bin/netstat
IPSET=/usr/sbin/ipset
IPTABLES=/sbin/iptables
SORT=/bin/sort
UNIQ=/usr/bin/uniq
srvIP=`$IFCONFIG eth0 | $GREP 'inet addr' | $AWK '{print $2}' | $CUT -f2 -d ":"`
for i in `$NETSTAT -ntu | $GREP SYN_RECV | $AWK '{print $5}' | $CUT -f1 -d ":" | $SORT | $UNIQ | $GREP -v ${srvIP}`
do
$IPSET -A dos $i
done
$IPSET -S > /etc/sysconfig/ipset

#
#russian info
#https://linux-notes.org/zashhita-ot-ddos-s-iptables-gotovy-j-skript/
#
