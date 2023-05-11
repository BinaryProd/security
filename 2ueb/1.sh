#!/bin/bash

cd /tmp || exit 1

temp_file=$(mktemp)
soft_link="soft_link"
hardlink="hard_link"

dd if=/dev/urandom of="$temp_file" bs=1M count=1

ls -l "$temp_file" || { echo "Error: ls -l doesn't work for $temp_file"; exit 1; }

ln "$temp_file" "$hardlink"
ln -s "$temp_file" "$soft_link"

ls -l "$hardlink" || { echo "Error: ls -l doesn't work for $hardlink"; exit 1; }
ls -l "$soft_link" || { echo "Error: ls -l doesn't work for $soft_link"; exit 1; }

tar -c -f "$hardlink".tar.gz "$hardlink" "$temp_file" 2> /dev/null
tar -c -f "$soft_link".tar.gz "$soft_link" "$temp_file"  2> /dev/null

ls -l "$hardlink".tar.gz
ls -l "$soft_link".tar.gz

# 1+0 Datensätze ein
# 1+0 Datensätze aus
# 1048576 Bytes (1,0 MB, 1,0 MiB) kopiert, 0,00959434 s, 109 MB/s
# -rw------- 1 idefux idefux 1048576 11. Mai 12:39 /tmp/tmp.ms7op6mqwJ
# lrwxrwxrwx 1 idefux idefux 19 11. Mai 12:39 soft_link -> /tmp/tmp.ms7op6mqwJ
# -rw-r--r-- 1 idefux idefux 1054720 11. Mai 12:39 hard_link.tar.gz
# -rw-r--r-- 1 idefux idefux 10240 11. Mai 12:39 soft_link.tar.gz

# When the original file is archived, it stores the actual data in the archive. 
# On the other hand, when the symbolic link is archived, it stores the path to the original file in the archive, not the actual data.
