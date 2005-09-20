default: print-styles

print-styles:
	@echo '' > styles.tmp && \
	for f in ~/texmf/tex/latex/powerdot/powerdot-*.sty; do \
		echo $$(basename $$f .sty)| sed -e 's/powerdot-//' | tee -a styles.tmp; \
	done

example-1:
	@for style in $$(cat styles.tmp); do \
		echo '\documentclass[a4paper,style='$$style']{powerdot}' > header.tex && \
		latex $@ && latex $@ > /dev/null 2>&1 && \
		dvips $@.dvi -o$@-$$style.ps && \
		ps2pdf $@-$$style.ps ; \
	done
