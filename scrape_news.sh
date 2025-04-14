#!/bin/bash
# creats tmp file to store site data and links data
touch data.txt 
touch link.txt
tfile="data.txt"
# reads data from site and saves all article links in article.txt without douplicates
wget -q -O $tfile https://www.ynetnews.com/category/3082
grep -o "https://www\.ynetnews\.com/article/[a-zA-Z0-9]*" $tfile | sort | uniq > article.txt
# counts how many articles we've got
count=$(wc -l < article.txt)
echo "$count"
file="article.txt"
tfile="link.txt"
# searches for leaders names in each article link and echos the number of occurance out
while IFS= read -r link; do
    wget -q -O $tfile $link
    bib=$(grep -ow "Netanyahu" $tfile | wc -l)
    naf=$(grep -ow "Bennet" $tfile | wc -l)
    gan=$(grep -ow "Gantz" $tfile | wc -l)
    per=$(grep -ow "Peretz" $tfile | wc -l)
    if [[ $bib -eq 0 && $naf -eq 0 && $gan -eq 0 && $per -eq 0 ]]; then 
        echo "$link, -"
    else 
        echo "$link, Netanyahu, $bib, Bennet, $naf, Gantz, $gan, Peretz, $per"
    fi
done < "$file"


