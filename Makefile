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
	$(DOC).tex $(DOC).tex $(DOC).ktvnum \
	pdpream.ble

clean:
	@0texclean
	@rm -fv *.{ps,bm,glo,bib} powerdot*.sty powerdot-example* powerdot-style* *.cls *-tcvn.*

backup:
	@zip -9r ~/backup/powerdot-doc-vi.zip ./ -x *.{dvi,ps,pdf,log,aux,toc,out,zip}

all: clean doc src dist backup
