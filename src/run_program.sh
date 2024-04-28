#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run_language.sh <filename>"
    exit 1
fi

# Tokenize the code
tokens=$(python3 tokenizer.py "$1")
