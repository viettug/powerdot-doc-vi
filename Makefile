POWERDOT = 1.3
DOC = powerdot-doc-vi
DOCDIST = powerdot-$(POWERDOT)-doc-vi
SRCDIST  = powerdot-$(POWERDOT)-src-vi
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

doc-fast:
	@rm -fv printctl.tex
	@latex $(DOC) && \
	dvips $(DOC).dvi -o$(DOC).ps && \
	ps2pdf $(DOC).ps

dist-doc:
	@rm -fv distro/$(DOCDIST)-$(VERSION).zip
	@zip -9r distro/$(DOCDIST)-$(VERSION).zip \
	$(DOC).pdf \
	img/{lst-bookmarks,tab-contents,tab-slide-contents}.png \
	README
	@zip -9r distro/powerdot-$(POWERDOT)-styles-vi-$(VERSION).zip \
	powerdot-eg-vi-paintings.pdf powerdot-eg-vi-*.jpg powerdot-eg-vi.tex \
	README.styles

dist-src:
	@rm -fv ./distro/$(SRCRIST)-src-$(VERSION).zip && \
	zip -9r ./distro/$(SRCDIST)-src-$(VERSION).zip \
	README TODO COPYING \
	Makefile \
	$(DOC).tex $(DOC).ktvnum \
	pd-preamble-vi.tex \
	powerdot-eg-vi.tex

dist: dist-doc dist-src

clean:
	@0texclean
	@rm -fv *.{bm,glo,bib} powerdot*.sty powerdot-example* powerdot-style* *.cls *.tmp

clean-all: example-clean-all clean

backup:
	@zip -9r ~/backup/powerdot-doc-vi.zip ./ -x *.{dvi,ps,pdf,log,aux,toc,out,zip}

all: clean doc example-all dist backup clean-all

known-styles:
	@echo '' > styles.tmp && \
	for f in ~/texmf/tex/latex/powerdot/powerdot-*.sty; do \
		echo $$(basename $$f .sty)| sed -e 's/powerdot-//' | tee -a styles.tmp; \
	done

example-compile: known-styles
	@latex $(EXAMPLE)
	@for S in $$(cat styles.tmp); do \
		latex '\def\style{'$$S"}\\input{$(EXAMPLE)}" ; \
		dvips $(EXAMPLE).dvi -o$(EXAMPLE)-$$S.ps ; \
	done
	@ps2pdf $(EXAMPLE)-paintings.ps

# sed commands: remove the 'Submit' button (set to white color)
example-images: known-styles
	@for S in $$(cat styles.tmp); do \
		psselect -p1-2 $(EXAMPLE)-$$S.ps $(EXAMPLE)-$$S.1 ; \
		psnup -2 $(EXAMPLE)-$$S.1 $(EXAMPLE)-$$S.2 ; \
		sed -e 's/Submit//g' $(EXAMPLE)-$$S.2 > $(EXAMPLE)-$$S.3 ; \
		sed -e 's/0\.6 setgray/1 setgray/g' $(EXAMPLE)-$$S.3 > $(EXAMPLE)-$$S.4 ; \
		sed -e 's/0\.34 setgray/1 setgray/g' $(EXAMPLE)-$$S.4 > $(EXAMPLE)-$$S.0 ; \
		convert -rotate 180 $(EXAMPLE)-$$S.0 $(EXAMPLE)-$$S.jpg ; \
		rm -fv powerdot-*.{1,2,3,4,0} ; \
	done

example-clean:
	@rm -fv $(EXAMPLE)-*.{jpg,png,pdf}

example-clean-all:
	@rm -fv $(EXAMPLE)-*.{ps,p1,p2,1,2,dvi}

example-all: example-compile example-images
