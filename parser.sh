#/bin/bash

# https://codingchallenges.fyi/challenges/challenge-json-parser/#step-zero
# This script is used to check whether the JSON provided is valid or not.
# first we will check if it is enclosed in curly braces or not.

# Check if the JSON is enclosed in curly braces or not.
validate_json() {
    local json="$1"

    # Check for empty string
    if [[ -z "$json" ]]; then
        return 1
    fi

    # Remove leading and trailing whitespace
    json=$(echo "$json" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    echo "$json"

    # Basic structure checks using Bash pattern matching
    if [[ "$json" =~ ^\{.*\}$ ]]; then 
        return 0
    else
        return 1
    fi
}

validate_json "$1"
