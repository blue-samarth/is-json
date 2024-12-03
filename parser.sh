#/bin/bash

# https://codingchallenges.fyi/challenges/challenge-json-parser/#step-zero
# This script is used to check whether the JSON provided is valid or not.
# first we will check if it is enclosed in curly braces or not.

# Check if the JSON is enclosed in curly braces or not.
validate_json() {
    # first we will remove all the white spaces from the JSON
    json=$(echo "$1" | tr -d '[:space:]')
    
    # Step 1: Check if the JSON is enclosed in curly braces or not.
    if [[ "${json:0:1}" != "{" || "${json: -1}" != "}" ]]; then 
        return 1
    fi
    
}