#!/bin/bash
# gather_sources.sh - Gather all .m sources for Hasdrubal's system prompt
# Uses code2prompt to create markdown representation of Mathematica sources

set -e

echo "Gathering Mathematica sources for Hasdrubal..."
echo ""

# Output files
OUTPUT_FILE="hamilcar_agents/hasdrubal_sources.md"
TEMP_DIR=$(mktemp -d)

# Track total tokens
TOTAL_TOKENS=0

# Function to extract token count from code2prompt output
extract_tokens() {
    local output="$1"
    # code2prompt outputs token count to stderr in format like "Token count: 12345"
    echo "$output" | grep -oP 'Token count: \K[0-9,]+' | tr -d ',' || echo "0"
}

# Remove existing output
rm -f "$OUTPUT_FILE"

# Header
cat > "$OUTPUT_FILE" << 'HEADER'
# Hasdrubal Source Context
# Generated Mathematica sources for in-context learning

This document contains the complete source code for:
1. Hamilcar - Canonical field theory package
2. Model Catalogue - Worked examples of Dirac-Bergmann constraint analysis

HEADER
date >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Section 1: Hamilcar
echo "## Processing Hamilcar..."
echo "" >> "$OUTPUT_FILE"
echo "# Section 1: Hamilcar Package Sources" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

HAMILCAR_OUTPUT="$TEMP_DIR/hamilcar.md"
HAMILCAR_RESULT=$(code2prompt /home/barker/Documents/Hamilcar \
    --include "*.m" \
    --exclude "*.mx" \
    --output-file "$HAMILCAR_OUTPUT" \
    --tokens "raw" 2>&1)

HAMILCAR_TOKENS=$(echo "$HAMILCAR_RESULT" | grep -oP 'Token count: \K[0-9]+' | head -1 || echo "0")
echo "   Hamilcar: $HAMILCAR_TOKENS tokens"
TOTAL_TOKENS=$((TOTAL_TOKENS + HAMILCAR_TOKENS))

cat "$HAMILCAR_OUTPUT" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Section 2: Model Catalogue from devel_catalogue
echo "## Processing Model Catalogue..."
echo "" >> "$OUTPUT_FILE"
echo "# Section 2: Model Catalogue" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Each model includes a canonical formulation (Hamiltonian, fields, momenta, multipliers) followed by a walkthrough of the Dirac-Bergmann constraint analysis if available." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

CATALOGUE_TOKENS=0

# Find all starter .md files that have accompanying walkthroughs
for starter in /home/barker/Documents/Hasdrubal/devel_catalogue/*.md; do
    if [ -f "$starter" ]; then
        STARTER_NAME=$(basename "$starter")
        THEORY_NAME="${STARTER_NAME%.md}"
        WALKTHROUGH="/home/barker/Documents/Hasdrubal/devel_catalogue/${THEORY_NAME}Walkthrough.m"

        # Only include if walkthrough exists
        if [ -f "$WALKTHROUGH" ]; then
            # Include starter .md
            echo "## $THEORY_NAME - Canonical Formulation" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
            cat "$starter" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"

            # Count tokens (approximate from file size)
            STARTER_SIZE=$(wc -c < "$starter")
            STARTER_TOKENS=$((STARTER_SIZE / 4))
            echo "   $STARTER_NAME: ~$STARTER_TOKENS tokens"
            CATALOGUE_TOKENS=$((CATALOGUE_TOKENS + STARTER_TOKENS))

            # Include walkthrough
            WALKTHROUGH_NAME=$(basename "$WALKTHROUGH")
            WALKTHROUGH_OUTPUT="$TEMP_DIR/$WALKTHROUGH_NAME.md"

            WALKTHROUGH_RESULT=$(code2prompt "$(dirname "$WALKTHROUGH")" \
                --include "$WALKTHROUGH_NAME" \
                --output-file "$WALKTHROUGH_OUTPUT" \
                --tokens "raw" 2>&1)

            TOKENS=$(echo "$WALKTHROUGH_RESULT" | grep -oP 'Token count: \K[0-9]+' | head -1 || echo "0")
            echo "   $WALKTHROUGH_NAME: $TOKENS tokens"
            CATALOGUE_TOKENS=$((CATALOGUE_TOKENS + TOKENS))

            echo "## $THEORY_NAME - Dirac-Bergmann Constraint Analysis Walkthrough" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
            cat "$WALKTHROUGH_OUTPUT" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"

            echo "----------------------------------------" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        else
            echo "   (Skipping $THEORY_NAME - no walkthrough)"
        fi
    fi
done

TOTAL_TOKENS=$((TOTAL_TOKENS + CATALOGUE_TOKENS))
echo "" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Cleanup
rm -rf "$TEMP_DIR"

# Summary
echo ""
echo "========================================" >> "$OUTPUT_FILE"
echo "# Token Summary" >> "$OUTPUT_FILE"
echo "Hamilcar: $HAMILCAR_TOKENS tokens" >> "$OUTPUT_FILE"
echo "Model Catalogue: $CATALOGUE_TOKENS tokens" >> "$OUTPUT_FILE"
echo "Total: $TOTAL_TOKENS tokens" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

echo ""
echo "========================================"
echo "TOKEN SUMMARY"
echo "========================================"
echo "Hamilcar:                      $HAMILCAR_TOKENS"
echo "Model Catalogue:               $CATALOGUE_TOKENS"
echo "----------------------------------------"
echo "TOTAL:                         $TOTAL_TOKENS tokens"
echo "========================================"
echo ""

# GPT-5.1 context limit check
GPT51_LIMIT=272000
if [ "$TOTAL_TOKENS" -gt "$GPT51_LIMIT" ]; then
    echo "WARNING: Total tokens ($TOTAL_TOKENS) exceeds GPT-5.1 limit ($GPT51_LIMIT)"
    echo "Consider excluding some sources or using selective includes."
else
    REMAINING=$((GPT51_LIMIT - TOTAL_TOKENS))
    echo "Within GPT-5.1 limit. Remaining capacity: $REMAINING tokens"
fi

echo ""
echo "Output written to: $OUTPUT_FILE"
echo "File size: $(wc -c < "$OUTPUT_FILE" | numfmt --to=iec-i --suffix=B 2>/dev/null || wc -c < "$OUTPUT_FILE")"
echo "Line count: $(wc -l < "$OUTPUT_FILE")"
