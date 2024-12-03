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

    # Basic structure checks using Bash pattern matching
    if ! [[ "$json" =~ ^\{.*\}$ || "$json" =~ ^\[.*\]$ ]]; then
        echo "Invalid JSON"
        return 1
    fi

    # now we will check against the key value pairs 
    # we will check if the key is enclosed in double quotes or not

    json=$(echo "$json" | sed 's/^{*//;s/}*$//')
    echo "$json"
    return 0
}

validate_json "$1"
