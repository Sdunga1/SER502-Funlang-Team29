
from pyswip import Prolog
from tokenize import *

def generate_parse_tree(filename):
    code = read_from_file(filename)

    tokens = tokenize_code(code)
    L = 'L = ' + str(tokens)

    query = L + ', program(P, L, []).'
    parsed_tree = list(prolog.query(query))
    return(parsed_tree[0]["P"])

prolog = Prolog()

prolog.consult("parser.pl")


filename = 'sample_programs/program_1.fl' 
print('\nParse tree for program 1:\n', generate_parse_tree(filename))
filename = 'sample_programs/program_2.fl'
print('\nParse tree for program 2:\n', generate_parse_tree(filename))
filename = 'sample_programs/program_3.fl'
print('\nParse tree for program 3:\n', generate_parse_tree(filename))
