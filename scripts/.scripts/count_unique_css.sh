#!/bin/bash
# Purpose: Count distinct non-comment text lines in CSS files.
# Usage: Run from the project root. The script scans frontend/src.
# Requirements: Bash and standard find, sed, grep, sort, uniq, awk, and wc commands.
# Supported systems: macOS and Linux.
# Limits: It trims outer whitespace and skips blank lines and lines that look like comments.
# It does not parse CSS, so it can count fragments rather than complete CSS rules.

echo "Scanning for CSS files..."
total_files=$(find frontend/src -name "*.css" | wc -l | awk '{print $1}')
echo "Found $total_files CSS files."

echo ""
echo "Calculating unique lines of CSS (stripping spaces, ignoring blanks & comments)..."

# Find all CSS, strip leading/trailing spaces, remove comments/blanks, sort, get unique, count
unique_lines=$(find frontend/src -name "*.css" -exec cat {} + | \
  sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
  grep -v '^\/\*' | \
  grep -v '^\*.*' | \
  grep -v '^$' | \
  sort | \
  uniq | \
  wc -l | awk '{print $1}')

echo "Grand Total: $unique_lines absolutely unique lines of CSS code!"
