#!/bin/bash
# Convert .txt catalogue output to .md with formatted code blocks
# Usage: txt2md.sh input.txt

input_file="$1"
output_file="${input_file%.txt}.md"

# Process each line: descriptions as text, code as code blocks
{
    while IFS= read -r line; do
        if [[ "$line" == "Here is"* ]]; then
            # Description line - output as plain text
            echo "$line"
            echo
        else
            # Code line - rearrange ConjugateMomentum pattern, then strip contexts
            cleaned=$(echo "$line" | sed -E 's/xAct`PSALTer`([A-Za-z]+)`([A-Za-z0-9]+)ConjugateMomentum/ConjugateMomentum\1\2/g')
            # Strip remaining xAct`PSALTer`
            cleaned=$(echo "$cleaned" | sed 's/xAct`PSALTer`//g')
            # Strip remaining backticks
            cleaned=$(echo "$cleaned" | sed 's/`//g')
            # Strip CanonicalField
            cleaned=$(echo "$cleaned" | sed 's/CanonicalField//g')
            echo '```mathematica'
            echo "$cleaned"
            echo '```'
            echo
        fi
    done
} < "$input_file" > "$output_file"

# Remove original .txt
rm "$input_file"
