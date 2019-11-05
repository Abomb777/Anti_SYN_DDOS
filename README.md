# Anti SYN DDOS (RHEL)
![Image description](https://image.shutterstock.com/image-photo/distributed-denial-service-ddos-attack-260nw-1070402450.jpg)
#### Check for SYN flood
> This attack is meaning to send lot of SYN packets to the server,this method very popular.
```sh
$ netstat -n --tcp | grep SYN_RECV
```
With count:
```sh
$ netstat -n --tcp | grep SYN_RECV | wc -l  
```
##### Attack Detect:
```sh
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
```


### Check for modules
List modules on server / pc:
```sh
$ ls /lib/modules/$(uname -r)/kernel/net/ipv4/netfilter/
```
Get information about each one of modules:
```sh
$ modinfo /lib/modules/$(uname -r)/kernel/net/ipv4/netfilter/*.xz
```

## Manul setup - step by step

Now you nead to check if tcp_syncookies is enabled:
> 1 - Enabled
> 0 - Disabled
```sh
$ cat /proc/sys/net/ipv4/tcp_syncookies
```
For enable syn cookies:
```sh
$ echo 1 > /proc/sys/net/ipv4/tcp_syncookies
```
Now we can check what is the maximum queue of connections:
```sh
$ cat /proc/sys/net/ipv4/tcp_max_syn_backlog
```
For increase the number to 40000 connections:
```sh
$ echo "40000" > /proc/sys/net/ipv4/tcp_max_syn_backlog
```
Now we check the number of connection retries:
```sh
$ cat /proc/sys/net/ipv4/tcp_synack_retries
```
We set the number to 1 (this means connection will wait less then 9 sec):
```sh
$ echo "1" > /proc/sys/net/ipv4/tcp_synack_retries
```
We check the time of FIN-WAIT-2 untile connection close:
```sh
$ cat /proc/sys/net/ipv4/tcp_fin_timeout
```
We check the time of FIN-WAIT-2 untile connection close (the socket will stay open at this time):
```sh
$ cat /proc/sys/net/ipv4/tcp_fin_timeout
```
Here we set the maximum time to 30 sec:
```sh
$ echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
```
We check the number of probs at keepalive, by default is 9:
```sh
$ cat /proc/sys/net/ipv4/tcp_keepalive_probes
```
Here we decrese the numbe of probs to 5:
```sh
$ echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
```
Lets check the interval betwinthe prob check (the default 75 sec):
```sh
$ cat /proc/sys/net/ipv4/tcp_keepalive_intvl
```
Lets set it to 15:
```sh
$ echo "15" > /proc/sys/net/ipv4/tcp_keepalive_intvl
```
The maximum namber of packets in queue before processing (the number of packets can be bigger then interface can process):
```sh
$ cat /proc/sys/net/core/netdev_max_backlog
```
Lets set it to 20000:
```sh
$ echo "20000" > /proc/sys/net/core/netdev_max_backlog
```
Check the maximum number of sockets:
```sh
$ cat /proc/sys/net/core/somaxconn
```
Lincrease the maximum number of sockets:
```sh
$ echo "20000" > /proc/sys/net/core/somaxconn
```

