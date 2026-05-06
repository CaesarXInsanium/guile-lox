guile=/usr/bin/guile
rootdir=$(shell pwd)
srcdir=$(rootdir)/src
testdir=$(rootdir)/tests

sources=$(shell fd --extension scm --search-path $(srcdir))
test-files=$(shell fd --extension scm --search-path $(testdir))

glox=$(rootdir)/bin/guile-lox

GUILE_LOAD_PATH=$(srcdir):...
export GUILE_LOAD_PATH


run:
ifdef script
	$(glox) $(script)
else
	@echo "Running REPL!"
	@printf "GUILE_LOAD_PATH=%s\n" $(GUILE_LOAD_PATH)
	$(glox)
endif

script:
ifdef script
	$(glox) $(script)
else
	@echo "Please provide a file path of script for guile-lox to run"
	@echo "make script=path/to/script.lox script"
endif

test:
ifdef test
	$(guile) -s $(testdir)/$(test)-test.scm
else
	./scripts/test $(test-files)
endif

help:
	@echo "Running Repl"
	@echo "make"
	@echo "Pass script to run"
	@echo "make script=path/to/script.lox"
clean:
	rm -rf *.log

tags: $(sources)
	ctags $^
