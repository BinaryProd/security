#! /bin/bash

ulimit -f 1

for ((i=1; i<=1000000; i++))
do
  echo "$i" >> aa.txt
done
