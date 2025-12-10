#!/bin/bash
# Convert .txt catalogue output to .md with formatted code blocks
# Usage: txt2md.sh input.txt
#
# This script obfuscates field names and coupling constants to prevent the LLM
# from recognising the theory from training data. Names are replaced with
# deterministic 8-character hashes.
#
# Example transformations:
#   xAct`PSALTer`VectorField`Rank10p[] -> Field<hash>[]
#   xAct`PSALTer`VectorField`Rank10pConjugateMomentum[] -> ConjugateMomentumField<hash>[]
#   xAct`PSALTer`VectorField`Rank10pLagrangeMultiplier[] -> Field<hash>LagrangeMultiplier[]
#   FirstKineticCoupling -> Coupling<hash>

input_file="$1"
output_file="${input_file%.txt}.md"

# Function to generate deterministic 8-char hash from a string
hash_name() {
    echo -n "$1" | md5sum | cut -c1-8
}

# Extract constant symbols from line 5
# Format: {FirstKineticCoupling, SecondKineticCoupling, ...}
constants_line=$(sed -n '5p' "$input_file")

# Extract constant names by parsing the list between { and }
# Remove braces, split by comma, trim whitespace
constants=()
constants_inner=$(echo "$constants_line" | sed 's/^{//; s/}$//')
IFS=',' read -ra const_array <<< "$constants_inner"
for const in "${const_array[@]}"; do
    const=$(echo "$const" | tr -d ' ')  # trim whitespace
    if [[ -n "$const" && ! " ${constants[*]} " =~ " ${const} " ]]; then
        constants+=("$const")
    fi
done

# Sort constants by length (longest first) to avoid substring replacement issues
IFS=$'\n' constants_sorted=($(printf '%s\n' "${constants[@]}" | awk '{ print length, $0 }' | sort -rn | cut -d' ' -f2-))
unset IFS

# Build sed commands for constants
sed_constants=""
for const in "${constants_sorted[@]}"; do
    hash=$(hash_name "$const")
    sed_constants="${sed_constants}s/${const}/Coupling${hash}/g;"
done

# Extract full field identifiers from line 7 (canonical fields list)
# Format: {xAct`PSALTer`VectorField`Rank10p[], xAct`PSALTer`VectorField`Rank11m[-a]}
canonical_fields_line=$(sed -n '7p' "$input_file")

# Extract full field identifiers (e.g., VectorFieldRank10p, VectorFieldRank11m)
# These are context+basename combined
field_ids=()
while IFS= read -r match; do
    # Extract context (e.g., VectorField) and basename (e.g., Rank10p)
    # Pattern: xAct`PSALTer`<context>`<basename>[...]
    context=$(echo "$match" | sed -E 's/xAct`PSALTer`([A-Za-z]+)`([A-Za-z0-9]+)\[.*/\1/')
    base=$(echo "$match" | sed -E 's/xAct`PSALTer`([A-Za-z]+)`([A-Za-z0-9]+)\[.*/\2/')
    full_id="${context}${base}"
    # Only add if not already in array
    if [[ ! " ${field_ids[*]} " =~ " ${full_id} " ]]; then
        field_ids+=("$full_id")
    fi
done < <(echo "$canonical_fields_line" | grep -oE "xAct\`PSALTer\`[A-Za-z]+\`[A-Za-z0-9]+\[-?[a-z]*\]")

# Build sed replacement commands for all field variants
sed_fields=""
for full_id in "${field_ids[@]}"; do
    hash=$(hash_name "$full_id")
    # Replace ConjugateMomentum<full_id> -> ConjugateMomentumField<hash>
    sed_fields="${sed_fields}s/ConjugateMomentum${full_id}/ConjugateMomentumField${hash}/g;"
    # Replace <full_id>LagrangeMultiplier -> Field<hash>LagrangeMultiplier
    sed_fields="${sed_fields}s/${full_id}LagrangeMultiplier/Field${hash}LagrangeMultiplier/g;"
    # Replace <full_id>CanonicalField -> Field<hash> (before stripping CanonicalField)
    sed_fields="${sed_fields}s/${full_id}CanonicalField/Field${hash}/g;"
    # Replace bare <full_id> -> Field<hash> (must come last to not interfere with above)
    sed_fields="${sed_fields}s/${full_id}/Field${hash}/g;"
done

# Combine all sed commands
sed_commands="${sed_constants}${sed_fields}"

# Process each line
{
    while IFS= read -r line; do
        if [[ "$line" == "This prompt"* ]] || [[ "$line" == "Here is"* ]] || [[ "$line" == "This is the end"* ]]; then
            # Description line - output as plain text
            echo "$line"
            echo
        else
            # Code line - first clean up xAct context prefixes
            # Rearrange ConjugateMomentum pattern: xAct`PSALTer`<ctx>`<base>ConjugateMomentum -> ConjugateMomentum<ctx><base>
            cleaned=$(echo "$line" | sed -E 's/xAct`PSALTer`([A-Za-z]+)`([A-Za-z0-9]+)ConjugateMomentum/ConjugateMomentum\1\2/g')
            # Strip remaining xAct`PSALTer` and merge context with basename
            cleaned=$(echo "$cleaned" | sed -E 's/xAct`PSALTer`([A-Za-z]+)`([A-Za-z0-9]+)/\1\2/g')
            # Strip any remaining backticks
            cleaned=$(echo "$cleaned" | sed 's/`//g')

            # Apply obfuscation (constants and fields)
            cleaned=$(echo "$cleaned" | sed "$sed_commands")

            echo '```mathematica'
            echo "$cleaned"
            echo '```'
            echo
        fi
    done
} < "$input_file" > "$output_file"

# Remove original .txt (disabled for debugging)
# rm "$input_file"
