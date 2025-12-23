#!/bin/bash
set -euo pipefail

# this script just takes some input and opens up a confluence URL
# to search this input.

URL="https://skyscanner.atlassian.net/wiki/search?text="

echo "Searching confluence"
echo
read -p "Enter search term: " search_term

# search_term=$(echo "$search_term" | sed 's/ /%20/g')
search_term=${search_term// /%20}

echo "Opening confluence search for: $search_term"
open "$URL${search_term}"
