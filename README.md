# SER502-Funlang-Team29
# **Overview:**
- This repository contains the source code, documentation, and demonstration materials for the implementation of "Funlang", a custom programming language designed and developed as part of a team project for the SER502 course.
- Dive into FUNLANG – a programming language designed to make writing code simpler, intuitive, and, most importantly, fun with every line of code.

# **Basic flow**
![IMG_0847](https://github.com/Sdunga1/SER502-Funlang-Team29/assets/165943559/b64831bf-2310-4cff-9ba8-4479af3aefb6)

TOOLS that are used: 
- The parsing technique that we would be utilizing for the project is a ‘Top-down’ descent parser. This is the common approach for parsing context-free grammars.
- Recursive Descent Parser: Each non-terminal in grammar corresponds to a parsing function. These functions recursively call each other to parse the input according to the grammar rules defined.


# **Instructions/Steps** to install:**

MacOS (Need to install Homebrew):

```homebrew install swi-prolog```

Python: refer to ```https://www.python.org/downloads/```

# **Src folder elements:**
- grammar.pl: grammar for Funlang
- tokenize.py: takes Funlang source code as input and generates a list of tokenized code with special characaters as seperate tokens
- parser.pl: takes a list of Funlang tokenized code as input and generates an appropriate parsed tree based on our grammar
- Evaluator.pl: takes a parsed Funlang program tree as input and evaluates the program
- run_program.sh: one liner bash script to invoke the parser and evaluator

# **How to run the one liner bash script:**
```./run_program.sh <file-path>/<file-name>```

# **Language Features**
- commands
- declaration
- data types
- keywords reserved
- arithmetic operations

# **Contributors**
- DARSH MANIAR
- SULTAN ALNEIF
- JINESH PATEL
- SARATH KUMAR DUNGA
- WILLIAM HUANG

# **Acknowledgements**
- Dr. Ajay Bansal

# **Link to the YOUTUBE video:**
```https://www.youtube.com/watch?v=I_y5bF1CH5c```
