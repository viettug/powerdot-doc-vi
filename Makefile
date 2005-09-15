DOC=powerdot-doc-vi
default: $(DOC) example-vi-1

doc: $(DOC)

$(DOC):
	@latex $@ && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf $@.ps

example-1:
	@cd exa && \
	latex $@ && latex $@ > /dev/null 2>&1 && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf $@.ps

dist:
	@rm -fv distro/$(DOC)-`gawk -F '=' '{print $$2}' $(DOC).ktvnum`.zip
	@zip -9r distro/$(DOC)-`gawk -F '=' '{print $$2}' $(DOC).ktvnum`.zip \
	exa/*{README,tex} \
	img/*png \
	$(DOC).pdf \
	README

clean:
	@0texclean
	@rm -fv *.{ps,bm,glo,bib}
