#!/usr/bin/env	bash

# Given a pf table called pfIngress that holds IPs to be allowed in,
# and given a dynamic DNS client run through ddclient,
# and given a text file (pfIngress.txt) holding FQDN for hosts that get updated with their ddclients:
# run a script to periodically update the pf table to ensure we allow
# desired hosts access to this machine.  

pfctl -t pfIngress -T show
ddclient
sleep 10
pfctl -t pfIngress -T replace -f /usr/local/etc/pf/location/pfIngress.txt
sleep 10
pfctl -t pfIngress -T show


