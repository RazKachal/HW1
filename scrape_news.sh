#!/bin/bash

# Step 1: Get article links from Ynetnews
article_links=$(wget -q -O - https://www.ynetnews.com/category/3082 | \
  grep -oP 'https://www\.ynetnews\.com/article/[a-zA-Z0-9]+' | \
  sort -u)

# Step 2: Print number of articles
article_count=$(echo "$article_links" | wc -l) 
echo "$article_count" 

# Step 3: Names to search for (case preserved for output)
names=("Netanyahu" "Gantz" "Bennett" "Peretz")

# Step 4: Process each article
while IFS= read -r link; do
  # Download article content
  content=$(wget -q -O - "$link")

  # Track counts
  declare -A counts
  total_found=0

  for name in "${names[@]}"; do
    count=$(echo "$content" | grep -o "$name" | wc -l)
    counts["$name"]=$count
    if [ "$count" -gt 0 ]; then
      total_found=$((total_found + 1))
    fi
  done

  # Format output
  if [ "$total_found" -eq 0 ]; then
    echo "$link, -"
  else
    output="$link"
    for name in "${names[@]}"; do
      output+=", $name, ${counts[$name]}"
    done
    echo "$output"
  fi

  # Unset associative array for next loop
  unset counts

done <<< "$article_links"
