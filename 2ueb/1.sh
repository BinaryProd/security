#!/bin/bash

cd /tmp || exit 1

temp_file=$(mktemp)
soft_link="soft_link"

dd if=/dev/urandom of="$temp_file" bs=1M count=1

ls -l "$temp_file" || { echo "Error: ls -l doesn't work for $temp_file"; exit 1; }

ln -s "$temp_file" "$soft_link"

ls -l "$soft_link" || { echo "Error: ls -l doesn't work for $soft_link"; exit 1; }


tar -c -f "$temp_file".tar.gz "$temp_file" 2> /dev/null
tar -c -f "$soft_link".tar.gz "$temp_file" 2> /dev/null

ls -l "$temp_file".tar.gz
ls -l "$soft_link".tar.gz

# -rw------- 1 idefux idefux 1048576  5. Mai 12:55 /tmp/tmp.R5ddRs4C3S
# lrwxrwxrwx 1 idefux idefux 19  5. Mai 12:55 soft_link -> /tmp/tmp.R5ddRs4C3S
# 
# -rw-r--r-- 1 idefux idefux 1054720  5. Mai 12:55 /tmp/tmp.R5ddRs4C3S.tar.gz
# -rw-r--r-- 1 idefux idefux 1054720  5. Mai 12:55 soft_link.tar.gz
#
# Selbe groesse aber groesser als orginal file

# 1+0 records in
# 1+0 records out
# 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.010608 s, 98.8 MB/s
# -rw------- 1 om3re om3re 1048576 May 10 23:41 /tmp/tmp.2SEXrF0nij
# lrwxrwxrwx 1 om3re om3re 19 May 10 23:41 soft_link -> /tmp/tmp.2SEXrF0nij
# -rw-r--r-- 1 om3re om3re 1054720 May 10 23:41 /tmp/tmp.2SEXrF0nij.tar.gz
# -rw-r--r-- 1 om3re om3re 1054720 May 10 23:41 soft_link.tar.gz