default: powerdot-doc-vi example-vi-1

doc: powerdot-doc-vi

powerdot-doc-vi:
	@latex $@ && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf $@.ps

example-1:
	@cd exa && \
	latex $@ && latex $@ > /dev/null 2>&1 && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf $@.ps

dist:
	@rm -fv distro/powerdot-doc-vi-$(gawk -F '=' '{print $2}' $@.ktvnum).zip
	@zip -9r distro/powerdot-doc-vi-$(gawk -F '=' '{print $2}' $@.ktvnum).zip exa/* img/* $@.pdf

clean:
	@0texclean
	@rm -fv *.{ps,bm,glo,bib}
