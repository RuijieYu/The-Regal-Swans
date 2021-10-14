ZIP = zip
ZIPARGS = -u

CHECKPOINTS = cp1 cp2 cp3 cp4 cp5
CP_ZIPS = $(patsubst cp%,checkpoint-%.zip,$(CHECKPOINTS))
.PHONY: $(CHECKPOINTS)

$(CHECKPOINTS): cp%: checkpoint-%.zip
$(CP_ZIPS): %.zip: | %/
	$(ZIP) $(ZIPARGS) $@ $| 2>/dev/null

%/:
	mkdir -p $@
