#!/bin/sh

echo "readMailForBadLogins.sh"

## This script will read the mail of the root account to look for IPs associated
## with bad logins.  Those IPs will be held in a working file for appending to
## pf bruteforcers.

cat /var/mail/root | grep "ssh" | grep "invalid user" | grep -v "www.xxx.yyy.zzz" | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" | sort -u >> ip.txt

BLOCKFILE="/usr/local/etc/pf/blocks/arbitraryBlocks.txt"

( cat ip.txt ${BLOCKFILE} ) | sort | uniq -c | awk '$1==1 {print $2}' > ${BLOCKFILE}

rm ip.txt

