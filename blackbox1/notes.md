My IP:172.16.64.10
Target network: 172.16.64.0/24

`nmap -sV 172.16.64.0/24`

Target IPs:
172.16.64.101
	22/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
	8080/tcp open  http    Apache Tomcat/Coyote JSP engine 1.1
	9080/tcp open  http    Apache Tomcat/Coyote JSP engine 1.1
172.16.64.140
	80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
172.16.64.182
	22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
172.16.64.199
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
1433/tcp open  ms-sql-s      Microsoft SQL Server 2014 12.00.2000

Let's try looking at .101 and .140 in the browser.

## 172.16.64.140
Opening http://172.16.64.140/ gives a 404. Let's try subdomain enum.
Interesting domains found from gobuster:
	/project (Status: 401)
		- Asks for admin credentials
		- admin:admin works!
		- No cookie associated, not sure if credentialed or not.
		- Looks like empty web template
	/server-status (Status: 403)
		- Forbidden

Moving on for now.  Let's check out the Apache server. Started Hydra for ssh on .101 in the background. 

---
## 172.16.64.101:8080
Subdomains on http://172.16.64.101:8080 (Tomcat server):
/host-manager (Status: 302)
/manager (Status: 302)
Both require admin access. Able to gain access with default creds (tomcat:s3cret)
Using default creds, I gained access via Metasploit.
[+] Username and password found in /etc/tomcat8/tomcat-users.xml - tomcat:tomcat
[+] Username and password found in /etc/tomcat8/tomcat-users.xml - tomcat:s3cret
[+] Username and password found in /etc/tomcat8/tomcat-users.xml - role1:tomcat
---

## 172.16.64.101:9080
/host-manager (Status: 302)
/manager (Status: 302)
/aDBCbqs8kMJn33hZ
	- found via Apache manager
	- interesting..
tomcat:s3cret works.
Let's try Metasploit again.
Same dumped configs as 8080 server.

## 172.16.64.182
Just ssh, nothing useful here besides brute-force.

## 172.16.64.199

```
 ============================================= 
|    Nbtstat Information for 172.16.64.199    |
 ============================================= 
Looking up status of 172.16.64.199
        WIN10           <20> -         B <ACTIVE>  File Server Service
        WIN10           <00> -         B <ACTIVE>  Workstation Service
        WORKGROUP       <00> - <GROUP> B <ACTIVE>  Domain/Workgroup Name
```
