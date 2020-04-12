# homemadeBlockScriptsPF
Simple IP block scripts in Bash for FreeBSD running pf firewall.  Script will read logs and add them to a file for use with a pf table. 

## Situation
sshd is enabled.  `mail`, log entries, and HIDS show that ssh login is repeatedly subjected to brute force attack.  

## Given:
These scripts were tested on a host running FreeBSD 12.1.
Bash has been installed.
The firewall selected was pf.
pf.conf holds a rule to read a text file and add its contents to a pf table for blocking:

```sh
table <arbitraryblocks> persist file "/usr/local/etc/pf/blocks/arbitraryBlocks.txt"
```
  
 ## Actions 
 The scripts will inspect files like:
```
/var/log/messages
/var/log/auth.log
```

The scripts will make files that retain their work, if relevant, in subdirectories of `/var/monitor`.

It can be useful to run the scripts with a cronjob.

It should be noted that FreeBSD also comes with its own `blacklistd` that works well for temporarily blocking infringing IPs.  Details are available, pre-installed, on FreeBSD 12.1 or later with `man blacklistd`.  
