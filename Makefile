default: powerdot-doc-vi example-vi-1

powerdot-doc-vi:
	@latex $@

example-vi-1:
	@latex $@ && latex $@ > /dev/null 2>&1
	@dvips $@.dvi -o$@.ps
	@ps2pdf $@.ps
