ZIP = zip
ZIPARGS = -u

CHECKPOINTS = cp1 cp2 cp3 cp4 cp5
CP_ZIPS = $(patsubst cp%,checkpoint-%.zip,$(CHECKPOINTS))
.PHONY: $(CHECKPOINTS)

REQUIRED_FILES = findings.pdf src/ README.md

$(CHECKPOINTS): cp%: checkpoint-%.zip
$(CP_ZIPS): %.zip: | %/
	@for f in $(REQUIRED_FILES); do test -e "$|$$f" || \
	echo "WARNING: $|$$f does not exist!"; done >&2
	$(ZIP) $(ZIPARGS) $@ $| 2>/dev/null

%/:
	mkdir -p $@
