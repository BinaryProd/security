#!/bin/bash

username=$1
n=$2

# Überprüfen, ob Benutzername und Anzahl angegeben wurden
if [ -z "$username" ] || [ -z "$n" ]; then
    echo "Bitte geben Sie Benutzername und Anzahl an."
    exit 1
fi

# Überprüfen, ob das Benutzerverzeichnis bereits existiert, andernfalls erstellen
user_dir="./$username"
if [ ! -d "$user_dir" ]; then
    mkdir -p "$user_dir/TAN"
fi

# TAN-Liste generieren und in Datei speichern
tan_file="$user_dir/TAN/list.txt"
if [ -f "$tan_file" ]; then
    echo "Die TAN-Liste existiert bereits."
    exit 1
fi

echo "TAN-Liste für Benutzer $username wird generiert..."

for (( i=1; i<=$n; i++ )); do
    number=$(shuf -i 0-9999999 -n 1)
    sha_256_hashed_rand=$( echo "$number" | openssl dgst -sha256 )
    echo "$number-> $sha_256_hashed_rand"
    echo "$sha_256_hashed_rand" >> "$tan_file"
done

echo "TAN-Liste wurde erfolgreich generiert und in $tan_file gespeichert."
