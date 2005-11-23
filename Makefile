POWERDOT = 1.3
DOC = powerdot-doc-vi
DOCDIST = powerdot-$(POWERDOT)-doc-vi
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
	ps2pdf $@.ps

dist-doc:
	@rm -fv distro/$(DOCDIST)-$(VERSION).zip
	@zip -9r distro/$(DOCDIST)-$(VERSION).zip \
	$(DOC).pdf \
	img/{lst-bookmarks,tab-contents,tab-slide-contents}.png \
	README
	@zip -9r distro/$(DOCDIST)-styles-$(VERSION).zip \
	powerdot-eg-vi-*.pdf powerdot-eg-vi.tex

dist-src:
	@rm -fv ./distro/$(DOC)-$(POWERDOT)-src-$(VERSION).zip && \
	zip -9r ./distro/$(DOC)-$(POWERDOT)-src-$(VERSION).zip \
	README TODO COPYING \
	Makefile \
	$(DOC).tex $(DOC).ktvnum \
	pd-preamble-vi.tex \
	powerdot-eg-vi.tex

dist: dist-doc dist-src

clean:
	@0texclean
	@rm -fv *.{bm,glo,bib} powerdot*.sty powerdot-example* powerdot-style* *.cls *.tmp

clean-all: example-clean clean

backup:
	@zip -9r ~/backup/powerdot-doc-vi.zip ./ -x *.{dvi,ps,pdf,log,aux,toc,out,zip}

all: clean doc src dist backup

known-styles:
	@echo '' > styles.tmp && \
	for f in ~/texmf/tex/latex/powerdot/powerdot-*.sty; do \
		echo $$(basename $$f .sty)| sed -e 's/powerdot-//' | tee -a styles.tmp; \
	done

example-compile: known-styles
	@latex $(EXAMPLE)
	@for S in $$(cat styles.tmp); do \
		latex '\def\style{'$$S"}\\input{$(EXAMPLE)}" ; \
		mv $(EXAMPLE).dvi $(EXAMPLE)-$$S.dvi ; \
		dvips $(EXAMPLE)-$$S.dvi ; \
		ps2pdf $(EXAMPLE)-$$S.ps ; \
	done

example-images: known-styles
	@for S in $$(cat styles.tmp); do \
		psselect -p1 $(EXAMPLE)-$$S.ps $(EXAMPLE)-$$S.1 ; \
		psselect -p2 $(EXAMPLE)-$$S.ps $(EXAMPLE)-$$S.2 ; \
	done

example-clean:
	@rm -fv $(EXAMPLE)-*.{p1,p2,1,2,dvi,pdf}

example-all: example-compile example-images
