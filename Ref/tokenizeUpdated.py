import re

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
        ('LEQUAL', r'<='),
        ('GEQUAL', r'>='),
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

# Testing
if __name__ == "__main__":
    
    filename = 'sample_programs/program_1.fl' 
    code = read_from_file(filename)

    tokens = tokenize_code(code)
    print('\nTokens for program_1: ', tokens)

    filename = 'sample_programs/program_2.fl' 
    code = read_from_file(filename)

    tokens = tokenize_code(code)
    print('\nTokens for program_2: ', tokens)

    filename = 'sample_programs/program_3.fl' 
    code = read_from_file(filename)

    tokens = tokenize_code(code)
    print('\nTokens for program_3: ', tokens)

    filename = 'sample_programs/program_4.fl' 
    code = read_from_file(filename)

    tokens = tokenize_code(code)
    print('\nTokens for program_4: ', tokens)

    filename = 'sample_programs/program_5.fl' 
    code = read_from_file(filename)

    tokens = tokenize_code(code)
    print('\nTokens for program_5: ', tokens)
