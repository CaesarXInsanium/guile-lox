---
title:  'GuileLox Docs'
subtitle: "Documentation for my implementation of Lox interpreter/compiler"
author:
- Caesar X Insanium
description: |
    Docs
toc: true
documentclass: article
---
# Purpose

New reason, to somehow find a way to learn things from the clox interpreter. I
finished the AST traversal in java, but I realize that some things with that
are not going to be easy going in Scheme/Guile.


# Things to Work On

- start work on parser
- start working on the bytecode interpreter
  -  start the bytecode tests 
- implement the full lexer
- remove references to Object member in token-record
- move this list to GitHub issues
- learn GitHub in order to do above
- RE reimplement the error system. do this shit again since it made things
  worse
  - update code to use the new error system
- add support for unsupported chars. Handle unrecognized chars
- add tests for lexer
- add tests for everything
- rename stuff to more fit the idea of lexer
- move testing infrastrure down to tests directory with its own Makefile

# TODO Build System and Testing

This is the section in which unnecessary files are removed. It is also how I am
going to redo the build system and testing infrastructure.

## How I want this project to be invoked?

Make seems to be the easiest, and most flexible but it also very complicated in
some ways and very simple in others. I must not make it a true build system.

## How are the tests run?

I have a directory of tests that can be run, however the build system is what
would be responsible for actually running them.

There is also the issue that `srfi-64` generates a log file mess. But only in
the directory from which the guile executable is being invoked.

It has come to my knowledge that I can disable test logging with this bit of
code.

```scheme
(set! test-log-to-file #f)
```

I remember that there are several things that need to be possible to do.

- run the repl
- pass a lox file to the interpreter
- run all tests
- run a particular test

If it is not enough then I will write a GNU Guile project management software
for this.

# Error Reporting

From here on out errors are values. Now how do I design an deal with this
concept is a different story. Maybe something that takes inspiration from
Haskell and Rust with options, error enums and panic attacks.

I will have to do a pseudocode files from here on out to make everything work
out.

# Lexer

What needs to happen is characters are read from a stack and peeked at. Based on
what characters are available we switch between different functions. We need to be
able to peek at different characters.

1. Peek Character
2. switch to function to scan certain token type

Characters are loaded from a source file. In Guile at the
end of a port there is a `EOF` object.

What if I just return the port? I get to preserve the state of the IO and also
be able to give more information about the error got in the first place.

This remains a state machine just like in the OOP/Imperative implementation
except that the state is represented by function, to more exact function calls.

# Token Types

We can easily define a token record. It will only be a scheme record, in fact
I can just copy and paste my old definition.

Maybe I can switch my definition of token type to an enumeration. We have a function
that can turn a symbol into a string.

With this I can just grind a function that can determine if a string is a token
keyword or an identifier. Which will then allow the creations of appropriate
token-type enum and record.

# Scanner

The state is stored in the GNU Guile runtime function stack.

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
line number with it. The only trouble would be keeping track of multi line constructs
with it.

There is also `port-line` and `port-column`.

with scan string, there is two options,
if char is quote, then check to see if `start` and `str` are defined, if not then
begin defining the string. if yes then begin returning the string lexeme and stuff

scan-number: port :optional digits found-period?

on first call scan-number is guaranteed to be digit?

If digits is empty, then it is first call, add to char to digits and continue

if digits is defined, and char is end-num? then make token

if period is found, then this implies that digits is defined, set found-period to true, add to digits
if second period is found then raise Guile error as placeholder for proper error handling.

if period is found and then char is somehow not digit? and is alpha? or alpha-symbol? or whitespace?
if found-period? is set and first elements of digits is period, then raise error

# Parser

What I have is a list of tokens. In Java we need some hacky shit in order to get
some metaprogramming with a program that outputs code that is then compiled again
and is used in the parser.

# Bytecode Generation
# Bytecode Interpretation
