DOC = powerdot-doc-vi

default: $(DOC) example-vi-1

latex: clean
	@latex $(DOC)

doc: $(DOC)

$(DOC):
	@rm -fv printctl.tex
	@latex $@ && latex $@ && latex $@ > /dev/null 2>&1 && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf14 $@.ps && \
	echo '\printtrue' > printctl.tex && \
	latex $@ && latex $@ > /dev/null 2>&1 && \
	dvips $@.dvi -o$@-print.ps && \
	ps2pdf14 $@-print.ps
	@rm -fv printctl.tex

example-1:
	@cd exa && \
	latex $@ && latex $@ > /dev/null 2>&1 && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf $@.ps

dist:
	@rm -fv distro/$(DOC)-`gawk -F '=' '{print $$2}' $(DOC).ktvnum`.zip
	@zip -9r distro/$(DOC)-`gawk -F '=' '{print $$2}' $(DOC).ktvnum`.zip \
	exa/*{README,tex,pdf} \
	img/*png \
	$(DOC).pdf $(DOC)-print.pdf \
	README

clean:
	@0texclean
	@rm -fv *.{ps,bm,glo,bib}
