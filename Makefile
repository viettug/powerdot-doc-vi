default: powerdot-doc-vi example-vi-1

powerdot-doc-vi:
	@latex $@ > /dev/null 2>&1

example-vi-1:
	@latex $@ > /dev/null 2>&1 && latex $@ > /dev/null 2>&1
	@dvips $@.dvi -o$@.ps > /dev/null 2>&1
	@ps2pdf $@.ps > /dev/null 2>&1
