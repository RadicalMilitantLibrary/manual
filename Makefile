###
#
# Todo:
#
# * use functions for repeating commands like rm
#   - https://www.gnu.org/software/make/manual/html_node/Call-Function.html#Call-Function
#
###

PANDOC	?= pandoc
PDFTEX		?= pdflatex
SED		?= sed
#file name
FN = readingclub-man
#input filename
IFN_MD = $(FN).markdown
#template(s) and additions for generated tex file(s)
TFN_TEX = $(FN)-wrapper.tex
#output filenames
OFN_LOG = make.log
OFN_HTM = $(FN).html
OFN_TEX = $(FN).tex
OFN_PDF = $(FN).pdf
OFN_ODT = $(FN).odt
OFN_EPUB = $(FN).epub
OFN_DOCX = $(FN).docx
OF = $(OFN_LOG) $(OFN_HTM) $(OFN_TEX) $(OFN_ODT) $(OFN_EPUB) $(OFN_PDF) $(OFN_DOCX)
#drop lengthy outfor for commands
NOOUT = > $(OFN_LOG) #/dev/null
NOERR = 2>&1

###
#
# inside targets:
#
# $@ is the target
# $^ is list of dependecies
# ...
#
# note: commands are a seperate shell,
#       so you cannot rely on the outcome of one for the next "line"
#
###

.PHONY: all

all: html5 pdf epub

html5:
	@$(PANDOC) -s -f markdown -t html5 -o $(OFN_HTM) $(IFN_MD) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" created successfully: "$(OFN_HTM) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed on: "$(OFN_HTM)""

epub:
	@$(PANDOC) -s -f markdown -t epub -o $(OFN_EPUB) $(IFN_MD) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" created successfully: "$(OFN_EPUB) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed on: "$(OFN_HTM)""

htm: html

html:
	@$(PANDOC) -s -f markdown -t $@ -o $(OFN_HTM) $(IFN_MD) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" created successfully: "$(OFN_HTM) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed on: "$(OFN_HTM)""

# call translation two times for toc
pdf: tex
	@$(PDFTEX) $(TFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" created successfully: "$(TFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed on: "$(TFN_TEX)
	@$(PDFTEX) $(TFN_TEX) $(NOOUT) $(NOERR) && mv $(FN)-wrapper.pdf $(OFN_PDF) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" created successfully: "$(OFN_PDF) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed on: "$(OFN_PDF)

tex:
	@$(PANDOC) -f markdown -t latex -o $(OFN_TEX) $(IFN_MD) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" created successfully: "$(OFN_TEX) || printf "\033[1;31m[ ❌ ]\033[0;39m "$@" failed creation on: "$(OFN_TEX)""
	@$(SED) -i 's/\\includegraphics/\\scalegraphics/g' $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted includegraphics successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of includegraphics on: "$(OFN_TEX)""
	@$(SED) -i 's/\\tightlist//g'  $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted includegraphics successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of includegraphics on: "$(OFN_TEX)""
	@$(SED) -i 's/\\toprule//g'  $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted toprule successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of toprule on: "$(OFN_TEX)""
	@$(SED) -i 's/\\midrule//g'  $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted midrule successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of midrule on: "$(OFN_TEX)""
	@$(SED) -i 's/\\bottomrule//g'  $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted bottomrule successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of bottomrule on: "$(OFN_TEX)""
	@$(SED) -i 's/\\textbar{}//g'  $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted textbar successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of textbar on: "$(OFN_TEX)""
#	@$(SED) -i 's/\\scalegraphics{}//g'  $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted scalgraphics successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of scalegraphics on: "$(OFN_TEX)""
#	@$(SED) -i 's/\[htbp\]//g' $(OFN_TEX) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted float-placement successfully: "$(OFN_TEX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution of float-placement on: "$(OFN_TEX)""

# odt opens in libre office with message: "error reading file" due to old pandoc version (1.11.1)
# works with e.g. 1.15.1
odt:
	$(PANDOC) -s -f markdown -t odt -o $(OFN_ODT) $(IFN_MD) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted includegraphics successfully: "$(OFN_ODT) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution on: "$(OFN_ODT)""

docx:
	$(PANDOC) -s -f markdown -t odt -o $(OFN_DOCX) $(IFN_MD) $(NOOUT) $(NOERR) && echo "\033[1;32m[ ✔ ]\033[0;39m "$@" substituted includegraphics successfully: "$(OFN_DOCX) || echo "\033[1;31m[ ❌ ]\033[0;39m "$@" failed substitution on: "$(OFN_DOCX)""

#delete targets
clean:
	@rm -f *.aux *.toc || true 
	@rm -f *.out >/dev/null 2>&1 || true

#delete intermediate files
cleanall: clean
	@rm -f *.log $(NOOUT) $(NOERR) || true
	@rm -f $(OF) $(NOOUT) $(NOERR) || true
