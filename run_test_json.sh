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


{
    printf "+--------------------------------+----------------------------------------------------+---------------+\n"
    printf "| %-30s | %-50s | %-13s |\n" "File Name" "File Content" "Validation Status"
    printf "+--------------------------------+----------------------------------------------------+---------------+\n"

    # Process each JSON file
    for file in test_data/step1/*.json; do
        # Increment total files
        total_files=$((total_files + 1))
        
        # Read the file content
        json=$(cat "$file")
        
        # Check for empty file
        if [[ -z "$json" ]]; then
            printf "| %-30s | %-50s | %-13s |\n" "$file" "Empty File" "Warning"
            warning_files=$((warning_files + 1))
            continue
        fi
        
        # Truncate content if too long
        truncated_content=$(echo "$json" | cut -c1-50)
        
        # Validate JSON
        if ./parser.sh "$json"; then
            printf "| %-30s | %-50s | %-13s |\n" "$file" "$truncated_content" "Valid"
            valid_files=$((valid_files + 1))
        else
            printf "| %-30s | %-50s | %-13s |\n" "$file" "$truncated_content" "Invalid"
            invalid_files=$((invalid_files + 1))
        fi
    done

    # Close the table
    printf "+--------------------------------+----------------------------------------------------+---------------+\n"

    # Summary section
    printf "\n----------------------------\n"
    printf "Summary:\n"
    printf "Total Files:    %d\n" "$total_files"
    printf "Valid Files:    %d\n" "$valid_files"
    printf "Invalid Files:  %d\n" "$invalid_files"
    printf "Warning Files:  %d\n" "$warning_files"
    printf "----------------------------\n"
} >> "$REPORT_FILE"

echo "Report saved to: $REPORT_FILE"
