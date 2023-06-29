#! /bin/bash

password1="07v0C21Z\$2FH7ib2Dxtoq6B83qTgON1"
password2="Jebn3vQ5\$2k..iqxtXNwfsCFAamWCS0"
password3="0ngrMRa1\$uXLzWhnrYzmiRM3fi8Nde1"
password4="1aaPttrp\$VoF2rkOyC/tE.DxzQuuIY1"
password5="7ieEwjFr\$T/jwatbzqhLZNVDEfymB41"

while IFS= read -r line; do
    for password in "$password1" "$password2" "$password3" "$password4" "$password5"; do
        hash="$(openssl passwd -1 -salt "$password" "$line")" 
        hash="${hash:3}"
        if [ "$hash" == "$password" ]; then
            echo "The password for $password is $line"
        fi
        echo "$line aa $password"
    done
#done < /usr/share/dict/words
done < words.txt

exit 0
