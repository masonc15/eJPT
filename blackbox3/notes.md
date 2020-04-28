# Black Box 3 Notes

My IP: `10.13.37.10`
Target subnet: `172.16.37.0/24`

My IP is in different subnet than target. Hmm... Let's take a look at route table.
```
default via 192.168.86.1 dev eth0 
10.13.37.0/24 dev tap0 proto kernel scope link src 10.13.37.10 
172.16.37.0/24 via 10.13.37.1 dev tap0 
192.168.86.0/24 dev eth0 proto kernel scope link src 192.168.86.124 
```
Let's ping scan both subnets:
10.13.37.1
172.16.37.1
172.16.37.220
172.16.37.234

.1 in both subnets is most likely gateway for each network.
`nmap -sS 10.13.37.1 172.16.37.1 172.16.37.220 172.16.37.234 --min-rate 1000`
Only one IP has any ports open, 80 on .220.
***
## 172.16.37.220
```
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
3307/tcp open  tcpwrapped
```
### HTTP (Port 80)
Looks like ifconfig output is hidden behind source of http://172.16.37.220/:
```
<!--ens192    Link encap:Ethernet  HWaddr 00:50:56:ba:91:e4  
          inet addr:172.16.37.220  Bcast:172.16.37.255  Mask:255.255.255.0
          inet6 addr: fe80::250:56ff:feba:91e4/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6801 errors:0 dropped:18 overruns:0 frame:0
          TX packets:3826 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:426191 (426.1 KB)  TX bytes:225362 (225.3 KB)

ens224    Link encap:Ethernet  HWaddr 00:50:56:ba:83:de  
          inet addr:172.16.50.222  Bcast:172.16.50.255  Mask:255.255.255.0
          inet6 addr: fe80::250:56ff:feba:83de/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:110 errors:0 dropped:15 overruns:0 frame:0
          TX packets:66 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:19796 (19.7 KB)  TX bytes:10273 (10.2 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:8632 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8632 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:642464 (642.4 KB)  TX bytes:642464 (642.4 KB)

-->
```
172.16.50.222 is interesting.  This is outside of the subnets we currently are targeting.

Let's also enumerate for subdomains.
403 Forbidden for http://172.16.37.220/javascript
Nothing else there.


***
## 172.16.37.234
```
PORT      STATE SERVICE VERSION
40121/tcp open  ftp     ProFTPD 1.3.0a
40180/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
```

### HTTP (Port 40180)
We get Apache default page on going to http://172.16.37.234:40180/.  Let's enumerate this as well.
`./recursive-gobuster.pyz -w /usr/share/seclists/Discovery/Web-Content/common.txt http://172.16.37.234:40180/ 2>/dev/null`

This finds http://172.16.37.234:40180/xyz which has another `ifconfig` output (unformatted):
```
ens192 Link encap:Ethernet HWaddr 00:50:56:ba:1b:44 inet addr:172.16.37.234 Bcast:172.16.37.255 Mask:255.255.255.0 inet6 addr: fe80::250:56ff:feba:1b44/64 Scope:Link UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1 RX packets:150596 errors:0 dropped:17 overruns:0 frame:0 TX packets:147268 errors:0 dropped:0 overruns:0 carrier:0 collisions:0 txqueuelen:1000 RX bytes:10274025 (10.2 MB) TX bytes:13033781 (13.0 MB) 

ens224 Link encap:Ethernet HWaddr 00:50:56:ba:79:c9 inet addr:172.16.50.224 Bcast:172.16.50.255 Mask:255.255.255.0 inet6 addr: fe80::250:56ff:feba:79c9/64 Scope:Link UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1 RX packets:69 errors:0 dropped:13 overruns:0 frame:0 TX packets:111 errors:0 dropped:0 overruns:0 carrier:0 collisions:0 txqueuelen:1000 RX bytes:10289 (10.2 KB) TX bytes:20550 (20.5 KB) 

lo Link encap:Local Loopback inet addr:127.0.0.1 Mask:255.0.0.0 inet6 addr: ::1/128 Scope:Host UP LOOPBACK RUNNING MTU:65536 Metric:1 RX packets:13309 errors:0 dropped:0 overruns:0 frame:0 TX packets:13309 errors:0 dropped:0 overruns:0 carrier:0 collisions:0 txqueuelen:1 RX bytes:990476 (990.4 KB) TX bytes:990476 (990.4 KB) 
```
172.16.50.224 is interesting.

I'm able to change index.php at http://172.16.37.234:40180/xyz/ to execute a PHP reverse shell, giving me access to Linux shell. From here, this machine has a route to 172.16.50.0/24 network. This machine also has nmap!

#### 172.16.50.222
```
PORT     STATE SERVICE    VERSION
22/tcp   open  ssh        OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http       Apache httpd 2.4.18 ((Ubuntu))
3307/tcp open  tcpwrapped
```
Was able to get in via ssh with `root:root`.
**Found flag!**

#### 172.16.50.224
```
PORT      STATE SERVICE VERSION
40121/tcp open  ftp     ProFTPD 1.3.0a
40180/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
```
### FTP (Port 40121)

```
ftp> open 172.16.37.234 40121
Connected to 172.16.37.234.
220 ProFTPD 1.3.0a Server (ProFTPD Default Installation. Please use 'ftpuser' to log in.) [172.16.37.234]
```
Need credentials to get any further here.
`ftpuser:ftpuser` works!
Found flag at /.flag.txt.
**Flag found!**


