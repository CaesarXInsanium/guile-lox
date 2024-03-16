# Purpose

The reason for making this repo is to make a fresh attempt at finding a
motivation to program something anything really. I can look at my other implementations
in order to get some idea on what sort of things I can work on.

Most of the planning and ideas will be done inside of a notebook so
yeah.

## Progress

Here I will track progress and ideas that I need to get my head in order

### Error Reporting

I have now clue on how to deal with this issue. Best case scenerio is that Guile
errors would be generated and returned with a proper backtrace.

Custom error types will be placed in the file `glox/error.scm`

Scheme RNRS has a section on Exceptions and conditions

### Lexer


What needs to happen is characters are read from a stack and peeked at. Based on
what characters are available we switch between different functions. We need to be
able to peek at different characters.

1. Peek Character
2. switch to function to scan certain token type

Characters are loaded from a source file. In Guile at the
end of a port there is a EOF object.

#### Token Types

We can easily define a token record. It will only be a scheme record, in fact
I can just copy and paste my old definition.

Maybe I can switch my definition of token type to an enumeration. We have a function
that can turn a symbol into a string.

With this I can just grind a function that can determine if a string is a token
keyword or an identifier. Which will then allow the creationg of appropiate
token-type enum and record.

#### Scanner

Contains internal state

Source string
: actual source of the code
Start index 
: denotes where the current token starts at
Current Index
: current index, state of the lexer
line number
: count the number of newlines that have been passed

Will require several functions to work correctly.

I just realized that there is a function called get-line. I can keep track of the
line number with it. The only trouble would be keeping track of multiline constructs
with it.

There is also `port-line` and `port-column`.

### Parser

### Code Generation
