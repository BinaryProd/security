#!/bin/bash

cd /tmp || exit 1

temp_file=$(mktemp)
soft_link="soft_link"

dd if=/dev/urandom of="$temp_file" bs=1M count=1

ls -l "$temp_file" || { echo "Error: ls -l doesn't work for $temp_file"; exit 1; }

ln -s "$temp_file" "$soft_link"

ls -l "$soft_link" || { echo "Error: ls -l doesn't work for $soft_link"; exit 1; }


tar -c -f "$temp_file".tar.gz "$temp_file" 2> /dev/null
tar -c -f "$soft_link".tar.gz "$soft_link" 2> /dev/null

ls -l "$temp_file".tar.gz
ls -l "$soft_link".tar.gz

# 1+0 Datensätze ein
# 1+0 Datensätze aus
# 1048576 Bytes (1,0 MB, 1,0 MiB) kopiert, 0,0059948 s, 175 MB/s
# -rw------- 1 idefux idefux 1048576 11. Mai 12:00 /tmp/tmp.6oIK6qxCJg
# ln: die symbolische Verknüpfung 'soft_link' konnte nicht angelegt werden: Die Datei existiert bereits
# lrwxrwxrwx 1 idefux idefux 19 11. Mai 11:57 soft_link -> /tmp/tmp.zVOcTpIEkX
# -rw-r--r-- 1 idefux idefux 1054720 11. Mai 12:00 /tmp/tmp.6oIK6qxCJg.tar.gz
# -rw-r--r-- 1 idefux idefux 10240 11. Mai 12:00 soft_link.tar.gz

# When the original file is archived, it stores the actual data in the archive. 
# On the other hand, when the symbolic link is archived, it stores the path to the original file in the archive, not the actual data.
