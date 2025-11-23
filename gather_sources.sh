#!/bin/bash
# gather_sources.sh - Gather all .m sources for Hasdrubal's system prompt
# Uses code2prompt to create markdown representation of Mathematica sources

set -e

echo "Gathering Mathematica sources for Hasdrubal..."
echo ""

# Output files
OUTPUT_FILE="hasdrubal_sources.md"
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
2. project-glavan/Private - Additional field theory computations
3. project-dalet/ReproductionOfResults - Reproduction results

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

# Section 2: project-glavan/Private (commented out - too large)
# echo "## Processing project-glavan/Private..."
# echo "" >> "$OUTPUT_FILE"
# echo "# Section 2: project-glavan/Private Sources" >> "$OUTPUT_FILE"
# echo "" >> "$OUTPUT_FILE"
#
# GLAVAN_OUTPUT="$TEMP_DIR/glavan.md"
# GLAVAN_RESULT=$(code2prompt /home/barker/Documents/project-glavan/Private \
#     --include "*.m" \
#     --exclude "*.mx" \
#     --output-file "$GLAVAN_OUTPUT" \
#     --tokens "raw" 2>&1)
#
# GLAVAN_TOKENS=$(echo "$GLAVAN_RESULT" | grep -oP 'Token count: \K[0-9]+' | head -1 || echo "0")
# echo "   project-glavan/Private: $GLAVAN_TOKENS tokens"
# TOTAL_TOKENS=$((TOTAL_TOKENS + GLAVAN_TOKENS))
#
# cat "$GLAVAN_OUTPUT" >> "$OUTPUT_FILE"
# echo "" >> "$OUTPUT_FILE"
# echo "========================================" >> "$OUTPUT_FILE"
# echo "" >> "$OUTPUT_FILE"
GLAVAN_TOKENS=0

# Section 3: project-dalet/ReproductionOfResults
echo "## Processing project-dalet/ReproductionOfResults..."
echo "" >> "$OUTPUT_FILE"
echo "# Section 3: project-dalet/ReproductionOfResults Sources" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

DALET_OUTPUT="$TEMP_DIR/dalet.md"
DALET_RESULT=$(code2prompt /home/barker/Documents/project-dalet/ReproductionOfResults \
    --include "*.m" \
    --exclude "*.mx" \
    --output-file "$DALET_OUTPUT" \
    --tokens "raw" 2>&1)

DALET_TOKENS=$(echo "$DALET_RESULT" | grep -oP 'Token count: \K[0-9]+' | head -1 || echo "0")
echo "   project-dalet/ReproductionOfResults: $DALET_TOKENS tokens"
TOTAL_TOKENS=$((TOTAL_TOKENS + DALET_TOKENS))

cat "$DALET_OUTPUT" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Section 4: Model Catalogue from devel_catalogue
echo "## Processing Model Catalogue..."
echo "" >> "$OUTPUT_FILE"
echo "# Section 4: Model Catalogue" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Each model includes a canonical formulation (Hamiltonian, fields, momenta, multipliers) followed by a walkthrough of the Dirac-Bergmann constraint analysis if available." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

CATALOGUE_TOKENS=0

# Find all starter .md files and pair with walkthroughs
for starter in /home/barker/Documents/Hasdrubal/devel_catalogue/*.md; do
    if [ -f "$starter" ]; then
        STARTER_NAME=$(basename "$starter")
        THEORY_NAME="${STARTER_NAME%.md}"
        WALKTHROUGH="/home/barker/Documents/Hasdrubal/devel_catalogue/${THEORY_NAME}Walkthrough.m"

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

        # Check for walkthrough
        if [ -f "$WALKTHROUGH" ]; then
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
        else
            echo "## $THEORY_NAME - Constraint Analysis" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
            echo "The application of the Dirac-Bergmann algorithm for $THEORY_NAME is left as an exercise. The user may request this analysis in the live session." >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
            echo "   (No walkthrough for $THEORY_NAME)"
        fi

        echo "----------------------------------------" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
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
echo "project-glavan/Private: $GLAVAN_TOKENS tokens" >> "$OUTPUT_FILE"
echo "project-dalet/ReproductionOfResults: $DALET_TOKENS tokens" >> "$OUTPUT_FILE"
echo "Model Catalogue: $CATALOGUE_TOKENS tokens" >> "$OUTPUT_FILE"
echo "Total: $TOTAL_TOKENS tokens" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

echo ""
echo "========================================"
echo "TOKEN SUMMARY"
echo "========================================"
echo "Hamilcar:                      $HAMILCAR_TOKENS"
echo "project-glavan/Private:        $GLAVAN_TOKENS"
echo "project-dalet/ReproductionOfResults: $DALET_TOKENS"
echo "Model Catalogue:               $CATALOGUE_TOKENS"
echo "----------------------------------------"
echo "TOTAL:                         $TOTAL_TOKENS tokens"
echo "========================================"
echo ""

# GPT-4o context limit check
GPT4O_LIMIT=128000
if [ "$TOTAL_TOKENS" -gt "$GPT4O_LIMIT" ]; then
    echo "WARNING: Total tokens ($TOTAL_TOKENS) exceeds GPT-4o limit ($GPT4O_LIMIT)"
    echo "Consider excluding some sources or using selective includes."
else
    REMAINING=$((GPT4O_LIMIT - TOTAL_TOKENS))
    echo "Within GPT-4o limit. Remaining capacity: $REMAINING tokens"
fi

echo ""
echo "Output written to: $OUTPUT_FILE"
echo "File size: $(wc -c < "$OUTPUT_FILE" | numfmt --to=iec-i --suffix=B 2>/dev/null || wc -c < "$OUTPUT_FILE")"
echo "Line count: $(wc -l < "$OUTPUT_FILE")"
