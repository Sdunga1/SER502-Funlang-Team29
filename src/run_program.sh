#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run_language.sh <filename>"
    exit 1
fi

# Tokenize the code
tokens=$(python3 tokenize.py "$1")

# Run the parser and save the parsed output
parsed_output=$(swipl -q -s parser.pl -g "phrase(program(Program), $tokens), writeq(Program), halt." -t "halt.") 
# Run the evaluator on the parsed output
evaluation_result=$(swipl -q -s Evaluator.pl -g "program_eval($parsed_output, []), halt." -t "halt.") 

# Display the evaluation result
echo "$evaluation_result"
