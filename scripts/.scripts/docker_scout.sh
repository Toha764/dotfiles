#!/bin/bash
# Purpose: Build the Compose omni profile and write Docker Scout vulnerability reports.
# Usage: Run beside the project Compose file.
# Requirements: Bash, Docker with Compose and Scout, and a running Docker daemon.
# Supported systems: macOS and Linux.
# Output: Replaces files in security-reports and writes a summary.txt file.
# Scope: Scans all local images. ONLY_CRITICAL=true limits reports to critical findings.
# Counts: The summary sets high, medium, and low counts to zero.

set -e

REPORT_STORE="security-reports"
SUMMARY_FILE="$REPORT_STORE/summary.txt"

# <<<<<<< change this
ONLY_CRITICAL=true
docker compose --profile omni build --no-cache
# ====================

mkdir -p "$REPORT_STORE"

TOTAL=0
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0

cat > "$SUMMARY_FILE" <<EOF
Docker Scout Security Summary
=============================
EOF

while read -r image; do

    echo "==== $image ===="

    image_name=$(echo "$image" | tr '/:' '__')
    report="$REPORT_STORE/${image_name}.txt"

    # generate full report
    scout_args=(cves --output "$report" "$image")
    $ONLY_CRITICAL && scout_args+=(--only-severity critical)
    docker scout "${scout_args[@]}"

    critical=$(grep -oE 'CVE-[0-9]{4}-[0-9]+' "$report" | sort -u | wc -l)
    high=0
    medium=0
    low=0

    {
        echo
        echo "$image"
        echo "  Critical: $critical"
        echo "  High:     $high"
        echo "  Medium:   $medium"
        echo "  Low:      $low"
    } >> "$SUMMARY_FILE"

done < <(docker images --format '{{.Repository}}:{{.Tag}}')

echo "===== SUMMARY ====="
cat "$SUMMARY_FILE"
