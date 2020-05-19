#!/usr/bin/env	bash

pfctl -t pfIngress -T show
ddclient
sleep 10
pfctl -t pfIngress -T replace -f /usr/local/etc/pf/location/pfIngress.txt
sleep 10
pfctl -t pfIngress -T show


