#
# $Id$
#
# Makefile by kyanh <kyanh@o2.pl>
#
# For `powerdot-doc-vn' bundle
# (vietnamese version of powerdot documentation)
#
# WARNING: this Makefile may*NOT* work on your system
# You should use it to know *HOWTO* compile.
# DO*NOT*COMPILE* the files using this `Makefile'
#

POWERDOT = 1.3
DOC = powerdot-doc-vn
DOCDIST = powerdot-$(POWERDOT)-doc-vn
SRCDIST  = powerdot-$(POWERDOT)-doc-vn
VERSION = `gawk -F '=' '{print $$2}' $(DOC).ktvnum`
EXAMPLE = powerdot-eg-vn
EXAMPLETCVN = powerdot-eg-tcvn

default: latex

latex:
	@latex -src-specials $(DOC)

doc: $(DOC)

$(DOC):
	@rm -fv printctl.tex
	@latex $@
	@latex $@
	@sed -e 's/|usage//g' $(DOC).idx > $(DOC).jdx
	@makeindex -s gind.ist -o $(DOC).ind $(DOC).jdx
	@latex $@
	@dvips $@.dvi -o$@.ps
	@ps2pdf $@.ps

doc-fast:
	@rm -fv printctl.tex
	@latex $(DOC) && \
	dvips $(DOC).dvi -o$(DOC).ps && \
	ps2pdf $(DOC).ps

dist-doc:
	@sed -e 's/utf8x/tcvn/' $(EXAMPLE).tex > tmp.tex
	@uvconv --from UTF-8 --to TCVN3 tmp.tex > $(EXAMPLETCVN).tex
	@rm -fv tmp.tex
	@rm -fv distro/$(DOCDIST)-$(VERSION).zip
	@zip -9r distro/$(DOCDIST)-$(VERSION).zip \
		$(DOC).pdf \
		img/{lst-bookmarks,tab-contents,tab-slide-contents}.png \
		README \
		$(EXAMPLE).tex \
		$(EXAMPLETCVN).tex
	@rm -fv distro/powerdot-$(POWERDOT)-styles-vn-$(VERSION).zip
	@zip -9r distro/powerdot-$(POWERDOT)-styles-vn-$(VERSION).zip \
		$(EXAMPLE)-paintings.pdf \
		README.styles \
		img/powerdot-*.jpg

dist-src:
	@rm -fv ./distro/$(SRCRIST)-src-$(VERSION).zip && \
	zip -9r ./distro/$(SRCDIST)-src-$(VERSION).zip \
		README COPYING \
		Makefile \
		$(DOC).tex $(DOC).ktvnum \
		pd-preamble-vn.tex \
		thanks.tex \
		notes.tex \
		introduction.tex \
		setup.tex \
		slides.tex \
		overlays.tex \
		structure.tex \
		misc.tex \
		styles.tex \
		compile.tex \
		createstyle.tex \
		lyx.tex \
		faq.tex \
		source.tex \
		bib.tex \
		title.tex \
		license.tex \
		abstract.tex \
		$(EXAMPLE).tex $(EXAMPLETCVN).tex

dist: dist-doc dist-src

clean:
	@0texclean
	@rm -fv *-tcvn.tex
	@rm -fv *.{bm,glo,bib,jdx,tmp,cls,tpt,gls} powerdot*.sty powerdot-example* powerdot-style*

clean-all: example-clean-all clean

backup:
	@zip -9r ~/backup/powerdot-doc-vn.zip ./ -x *.{dvi,ps,pdf,log,aux,toc,out,zip}

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
		sed -e 's/Submit//g' \
			-e 's/0\.6 setgray/1 setgray/g' \
			-e 's/0\.34 setgray/1 setgray/g' \
			$(EXAMPLE)-$$S.2 \
			> $(EXAMPLE)-$$S.0 ; \
		convert -rotate 180 $(EXAMPLE)-$$S.0 $(EXAMPLE)-$$S.jpg ; \
		mv -v $(EXAMPLE)-$$S.jpg img/ ; \
		rm -fv powerdot-*.{1,2,3,4,0} ; \
	done

example-clean:
	@rm -fv $(EXAMPLE)-*.{ps,p1,p2,1,2,dvi}

example-clean-all:
	@rm -fv $(EXAMPLE)-*.{ps,p1,p2,1,2,dvi}

example-all: example-compile example-images

# i don't why... there are many `|hyperpage' that cause errors :(
index:
#	@sed -e 's/|hyperpage//g' $(DOC).idx > $(DOC).jdx
	@sed -e 's/|usage//g' $(DOC).idx > $(DOC).jdx
	@makeindex -s gind.ist -o $(DOC).ind $(DOC).jdx

doc-print:
	@echo '\printtrue' > printctl.tex
	@latex $(DOC)
	@latex $(DOC)
	@latex $(DOC)
	@dvips $(DOC).dvi -o $(DOC)-print.ps
	@ps2pdf $(DOC)-print.ps
