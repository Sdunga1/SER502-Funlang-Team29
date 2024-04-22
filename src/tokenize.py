import re

def tokenize_code(code):
    token_patterns = [
        ('VAR', r'var'),
        ('IDENTIFIER', r'[a-zA-Z_]\w*'),
        ('NUMBER', r'\d+'),
        ('OPERATOR', r'[+\-*/=]'),
        ('SEMICOLON', r';'),
        ('LPAREN', r'\('),
        ('RPAREN', r'\)'),
        ('QUOTED_STRING', r'"([^"]*?)"'), 
        ('CURLY_OPEN', r'{'),
        ('CURLY_CLOSE', r'}'),
        ('SQUARE_OPEN', r'\['),
        ('SQUARE_CLOSE', r'\]'),
        ('COMMA', r','),
        ('COLON', r':'),
    ]

    patterns = '|'.join(f'(?P<{name}>{pattern})' for name, pattern in token_patterns)
    regex = re.compile(patterns)

    tokens = []
    for match in regex.finditer(code):
        token_type = match.lastgroup
        token_value = match.group()
        if token_type == 'QUOTED_STRING':
            words = re.findall(r'\b\w+\b', token_value)
            tokens.extend(['"'] + words + ['"'])
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
