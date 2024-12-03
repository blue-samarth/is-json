#/bin/bash

# https://codingchallenges.fyi/challenges/challenge-json-parser/#step-zero
# This script is used to check whether the JSON provided is valid or not.
# first we will check if it is enclosed in curly braces or not.

# Check if the JSON is enclosed in curly braces or not.
validate_json() {
    local json="$1"
    
    validate_brackets() {
        local str="$1"
        local open_brackets=0
        local close_brackets=0
        local in_string=false
        local prev_char=""
        
        for ((i=0; i<${#str}; i++)); do
            local char="${str:$i:1}"
            
            # Track if we're inside a string
            if [[ "$char" == '"' && "$prev_char" != '\' ]]; then
                $in_string && in_string=false || in_string=true
            fi
            
            # Skip checks inside strings
            if ! $in_string; then
                case "$char" in
                    "{") ((open_brackets++)) ;;
                    "}") ((close_brackets++)) ;;
                    "[") ((open_brackets++)) ;;
                    "]") ((close_brackets++)) ;;
                esac
            fi
            
            prev_char="$char"
        done
        
        [[ $open_brackets -eq $close_brackets ]]
    }
    
    validate_strings() {
        local str="$1"
        local in_string=false
        local prev_char=""
        
        for ((i=0; i<${#str}; i++)); do
            local char="${str:$i:1}"
            
            # Check for unescaped control characters in strings
            if $in_string; then
                if [[ "$char" =~ ^[[:cntrl:]]$ && "$prev_char" != '\' ]]; then
                    return 1
                fi
            fi
            
            # Toggle string state
            if [[ "$char" == '"' && "$prev_char" != '\' ]]; then
                $in_string && in_string=false || in_string=true
            fi
            
            prev_char="$char"
        done
        
        ! $in_string  # Ensure all strings are closed
    }
    
    validate_numbers() {
        local str="$1"
        # Check for leading zeros
        if [[ "$str" =~ (^|[^0-9])(0[0-9]+|0x[0-9a-fA-F]+) ]]; then
            return 1
        fi
        
        # Check for invalid number formats
        if [[ "$str" =~ (^|[^0-9])[0-9]+[eE]([+-]?[0-9]+)?[^0-9] ]]; then
            return 1
        fi
        
        return 0
    }
    
    validate_keys() {
        local str="$1"
        # Check for unquoted keys
        if [[ "$str" =~ \{[^"]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*: ]]; then
            return 1
        fi
        
        # Check for single quotes
        if [[ "$str" =~ \'[^\']*\' ]]; then
            return 1
        fi
        
        return 0
    }
    
    # Remove whitespace for basic parsing
    json=$(echo "$json" | tr -d '[:space:]')
    
    # Run all validations
    if ! validate_brackets "$json"; then
        echo "Invalid JSON: Mismatched brackets"
        return 1
    fi
    
    if ! validate_strings "$json"; then
        echo "Invalid JSON: Invalid string formatting"
        return 1
    fi
    
    if ! validate_keys "$json"; then
        echo "Invalid JSON: Invalid key formatting"
        return 1
    fi
    
    # More specific validations can be added here
    
    echo "JSON is valid"
    return 0
}
