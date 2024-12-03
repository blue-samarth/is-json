#!/bin/bash

# https://codingchallenges.fyi/challenges/challenge-json-parser/#step-zero
mkdir -p reports
REPORT_FILE="reports/json_validation_$(date +"%Y%m%d_%H%M%S").txt"

echo "JSON Validation Report" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "----------------------------" >> "$REPORT_FILE"

total_files=0
valid_files=0
invalid_files=0
warning_files=0


for file in test/*.json; do
    total_files=$((total_files + 1))
    
    json=$(cat "$file")
    if [[ -z "$json" ]]; then
        echo "Warning: Empty file: $file" >> "$REPORT_FILE"
        warning_files=$((warning_files + 1))
        continue
    fi

    if ./parser.sh "$json"; then
        echo "Valid JSON: $file" >> "$REPORT_FILE"
        valid_files=$((valid_files + 1))
    else
        echo "Invalid JSON: $file" >> "$REPORT_FILE"
        invalid_files=$((invalid_files + 1))
    fi
done

echo "----------------------------" >> "$REPORT_FILE"
echo "Total Files: $total_files" >> "$REPORT_FILE"
echo "Valid Files: $valid_files" >> "$REPORT_FILE"
echo "Invalid Files: $invalid_files" >> "$REPORT_FILE"
echo "Warning Files: $warning_files" >> "$REPORT_FILE"
echo "----------------------------" >> "$REPORT_FILE"

echo "Report saved to: $REPORT_FILE"