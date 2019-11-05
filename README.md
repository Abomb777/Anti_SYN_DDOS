# Anti SYN DDOS (RHEL)

### Check first
List modules on server / pc:
```sh
$ ls /lib/modules/$(uname -r)/kernel/net/ipv4/netfilter/
```
Get information about each one of modules:
```sh
$ modinfo /lib/modules/$(uname -r)/kernel/net/ipv4/netfilter/*.xz
```


#### Check for SYN flood
> This attack is meaning to send lot of SYN packets to the server,this method very popular.
```sh
$ netstat -n --tcp | grep SYN_RECV
```
With count:
```sh
$ netstat -n --tcp | grep SYN_RECV | wc -l  
```

Now you nead to check if tcp_syncookies is enabled:
> 1 - Enabled
> 0 - Disabled
```sh
$ cat /proc/sys/net/ipv4/tcp_syncookies
```
