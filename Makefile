# Author: Dominik Harmim <xharmi00@stud.fit.vutbr.cz>

PROG := flp20-log
TESTS := tests
PACK := flp-log-xharmi00.zip


.PHONY: build
build: $(PROG)

$(PROG): *.pl
	swipl -q --goal=simulate --stand_alone=true -o $@ -c $^


.PHONY: pack
pack: $(PACK)

$(PACK): Makefile README.md *.pl $(TESTS)
	zip -r $@ $^


.PHONY: clean
clean:
	rm -f $(PROG) $(PACK)
