#!/bin/bash
trap "" SIGINT

while true; do
  echo "Bitte geben Sie den Benutzernamen ein:"
  read username

  echo "Bitte geben Sie die TAN ein:"
  read entered_tan

  tan_file="./$username/TAN/list.txt"

  if [ ! -f "$tan_file" ]; then
    echo "Zugriff verweigert. Benutzer $username existiert nicht oder hat keine TAN-Liste."
    continue
  fi

  sha_256_hashed_tan=$( echo "$entered_tan" | openssl dgst -sha256 )
  if grep -q "$sha_256_hashed_tan" "$tan_file"; then
    echo "Zugriff erlaubt."
    sed -i "/$entered_tan/d" "$tan_file"
    exit 0 
  else
    echo "Zugriff verweigert. Falsche TAN."
  fi
done
