DOC = powerdot-doc-vi
DOCDIST = powerdot-1.1-doc-vi
VERSION = `gawk -F '=' '{print $$2}' $(DOC).ktvnum`
EXAMPLE = powerdot-eg-vi

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

dist:
	@rm -fv distro/$(DOCDIST)-$(VERSION).zip
	@zip -9r distro/$(DOCDIST)-$(VERSION).zip \
	exa/*{README,tex} exa/example-1.pdf \
	$(DOC).pdf $(DOC)-print.pdf \
	img/{lst-bookmarks,tab-contents,tab-slide-contents}.png \
	README
	@cd img && \
	rm -fv ../distro/powerdot-styles.zip && \
	zip -9r ../distro/powerdot-styles.zip powerdot*.png README

src:
	@svn log $(DOC).tex > ChangeLog
	@rm -fv ./distro/$(DOC)-src-$(VERSION).zip && \
	zip -9r ./distro/$(DOC)-src-$(VERSION).zip \
	README COPYING ChangeLog \
	Makefile \
	$(DOC).tex $(DOC).ktvnum \
	pd-preamble-vi.tex \
	powerdot-eg-vi.tex

clean:
	@0texclean
	@rm -fv *.{ps,bm,glo,bib} powerdot*.sty powerdot-example* powerdot-style* *.cls *.tmp

backup:
	@zip -9r ~/backup/powerdot-doc-vi.zip ./ -x *.{dvi,ps,pdf,log,aux,toc,out,zip}

all: clean doc src dist backup

known-styles:
	@echo '' > styles.tmp && \
	for f in ~/texmf/tex/latex/powerdot/powerdot-*.sty; do \
		echo $$(basename $$f .sty)| sed -e 's/powerdot-//' | tee -a styles.tmp; \
	done

example: known-styles
	@for S in $$(cat styles.tmp); do \
		latex '\def\style{'$$S"}\\input{$(EXAMPLE)}" ; \
		mv $(EXAMPLE).dvi $(EXAMPLE)-$$S.dvi ; \
		dvips $(EXAMPLE)-$$S.dvi ; \
		psselect $(EXAMPLE)-$$S.ps -p1 $(EXAMPLE)-$$S.t1 ; \
		psselect $(EXAMPLE)-$$S.ps -p2 $(EXAMPLE)-$$S.t2 ; \
		ps2pdf $(EXAMPLE)-$$S.t1 $(EXAMPLE)-$$S.1 ; \
		ps2pdf $(EXAMPLE)-$$S.t1 $(EXAMPLE)-$$S.2 ; \
	done
