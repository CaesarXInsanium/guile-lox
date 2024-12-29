guile:= '/usr/bin/guile'
export sources := `fd --extension scm --search-path src`
export test-files:= `fd --extension scm --search-path tests`
export GUILE_LOAD_PATH:="src:..."

run path:
  ./bin/guile-lox {{path}}

repl:
  ./bin/guile-lox

test TEST:
  @guile -L src -l tests/{{TEST}}.scm

test-all:
  ./test

clean:
  rm *.log
tags:
  ctags $sources
