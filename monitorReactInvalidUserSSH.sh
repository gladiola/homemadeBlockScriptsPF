#!/usr/bin/env bash

## Create directory to hold this work
BASEDIRECTORY='/var/monitor/monitorInvalidUserSSH/'
BASENAME='monitorInvalidUserSSH_'
COPYTIME=`date +"%Y%m%d%H%M%S"`
DIRNAME=${BASEDIRECTORY}${BASENAME}${COPYTIME}

mkdir -p ${DIRNAME}

## Be able to interact with a file that holds blocks for the firewall
BLOCKFILE='/usr/local/etc/pf/blocks/arbitraryBlocks.txt'

## I.  Read /var/log/messages and look for invalid users and store their IPs in a file.
touch ${DIRNAME}/ip.txt
tail -n 500 /var/log/messages | grep -E ".*error.*invalid user.*ssh*" | \
grep -v "www.xxx.yyy.zzz" | \		# PROTECT AN IP BY FILTERING IT OUT HERE
grep -E -o "(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)" | \
sort -u >> ${DIRNAME}/ip.txt

## II.  Read the BLOCKFILE used by firewall and determine if any IPs discovered would be an addition
SCORE=0

for ip in `cat ${DIRNAME}/ip.txt`; do
        grep -q $ip $BLOCKFILE
        if [[ $? != 0 ]]; then
                # append the ip to the BLOCKFILE
                echo ${ip} >> $BLOCKFILE;
                SCORE=$((SCORE+1))
        fi
done

## III.  Automatically reload the BLOCKFILE text file into the pf table

if [ $((SCORE)) -gt 0 ]; then
        pfctl -t arbitraryblocks -T replace -f $BLOCKFILE
fi

## IV. Cleanup work files.

# If nothing significant was found, then delete the work directory.
if [ $((SCORE)) -eq 0 ]; then
        rm -r ${DIRNAME}
fi


