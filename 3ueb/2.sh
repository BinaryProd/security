#!/bin/bash

fussball="fussball-tabelle.html"

curl https://de.wikipedia.org/wiki/Fußball-Bundesliga_2022/23 -o "$fussball" >/dev/null 2>/dev/null

begin=$(grep -E "table.*wikitable sortable" fussball-tabelle.html -n | cut -f1 -d ":" | head -1)
numbers=$(grep -E "</tbody></table>" fussball-tabelle.html -n | cut -f1 -d ":" )
end=0

for number in $numbers; do
    if [ "$number" -gt "$begin" ]; then
        end="$number"
        break
    fi
done

a=$(cat < fussball-tabelle.html | head -n "$end" | tail -n $(("$end" - "$begin" + 1)))

needed_line=$(echo "$a" | grep -E 'td.*style="text-align:left')
almost=$(echo "$needed_line" | sed 's/.*>\([^<]*\)<\/a>.*/\1/g')

echo "$almost" | nl -w1 -s". "

rm "$fussball"
