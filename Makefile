DOC = powerdot-doc-vi
DOCDIST = powerdot-1.1-doc-vi

default: latex

latex:
	@latex -src-specials $(DOC)

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
	echo '\documentclass[a4paper,style=default]{powerdot}' > header.tex & \
	latex $@ && latex $@ > /dev/null 2>&1 && \
	dvips $@.dvi -o$@.ps && \
	ps2pdf $@.ps

dist:
	@rm -fv distro/$(DOCDIST)-`gawk -F '=' '{print $$2}' $(DOC).ktvnum`.zip
	@zip -9r distro/$(DOCDIST)-`gawk -F '=' '{print $$2}' $(DOC).ktvnum`.zip \
	exa/*{README,tex} exa/example-1.pdf \
	$(DOC).pdf $(DOC)-print.pdf \
	img/{lst-bookmarks,tab-contents,tab-slide-contents}.png \
	README
	@cd img && \
	rm -fv ../distro/powerdot-styles.zip && \
	zip -9r ../distro/powerdot-styles.zip powerdot*.png README

clean:
	@0texclean
	@rm -fv *.{ps,bm,glo,bib} powerdot*.sty powerdot-example* powerdot-style* *.cls

backup:
	@zip -9r ~/backup/powerdot-doc-vi.zip ./ -x *.{dvi,ps,pdf,log,aux,toc,out,zip}
