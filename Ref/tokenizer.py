import re
import sys

def tokenize_code(code):
    token_patterns = [
        ('VAR', r'\bvar\b'),
        ('IDENTIFIER', r'\b[a-zA-Z_]\w*\b'),
        ('NUMBER', r'\b\d+\b'),
        ('OPERATOR', r'[+\-*/=]'),
        ('SEMICOLON', r';'),
        ('LPAREN', r'\('),
        ('RPAREN', r'\)'),
        ('QUOTED_STRING', r'"[^"]*"'),
        ('CURLY_OPEN', r'{'),
        ('CURLY_CLOSE', r'}'),
        ('SQUARE_OPEN', r'\['),
        ('SQUARE_CLOSE', r'\]'),
        ('COMMA', r','),
        ('COLON', r':'),
        ('GTHAN', r'>='),
        ('LT', r'<'),
        ('GT', r'>'),
        ('EQUAL', r'=='),
        ('NEQUAL', r'!=')
    ]

    patterns = '|'.join(f'(?P<{name}>{pattern})' for name, pattern in token_patterns)
    regex = re.compile(patterns)

    tokens = []
    for match in regex.finditer(code):
        token_type = match.lastgroup
        token_value = match.group()
        if token_type == 'QUOTED_STRING':
            tokens.extend(['"', match.group(0)[1:-1], '"'])
        else:
            tokens.append(token_value)

    return tokens

def read_from_file(filename):
    with open(filename, 'r') as file:
        code = file.read()
    return code

if __name__ == "__main__":
    # Check if filename is provided as an argument
    if len(sys.argv) != 2:
        print("Usage: python tokenizer.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]
    
    try:
        # Read code from file
        code = read_from_file(filename)
        
        # Tokenize the code
        tokens = tokenize_code(code)
        
        # Print tokens
        print(tokens,end="")
        
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        sys.exit(1)
