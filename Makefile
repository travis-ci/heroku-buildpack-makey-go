BATS ?= bats
ECHO ?= echo

.PHONY: test
test:
	@$(foreach b,\
		$(wildcard test/*.bats),\
		$(ECHO) "---> $(BATS) $(b)" && $(BATS) $(b);$(ECHO);)
