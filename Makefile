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
IFN_MD = $(FN).md
#template(s) and additions for generated tex file(s)
TFN_TEX = $(FN)-wrapper.tex
#output filenames
OFN_LOG = make.log
OFN_HTM = $(FN).html
OFN_TEX = $(FN).tex
OFN_PDF = $(FN).pdf
OFN_ODT = $(FN).odt
OFN_EPUB = $(FN).epub
OF = $(OFN_LOG) $(OFN_HTM) $(OFN_TEX) $(OFN_ODT)
#drop lengthy outfor for commands
#NOOUT = > $(OFN_LOG) #/dev/null
#NOERR = 2>&1

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
	@$(PANDOC) -s -f markdown -t html5 -o $(OFN_HTM) $(IFN_MD) $(NOOUT) $(NOERR) && echo "[ K ] "$@" created successfully: "$(OFN_HTM) || echo "[ E ] "$@" failed on: "$(OFN_HTM)""

epub:
	@$(PANDOC) -s -f markdown -t epub -o $(OFN_EPUB) $(IFN_MD) $(NOOUT) $(NOERR) && echo "[ K ] "$@" created successfully: "$(OFN_EPUB) || echo "[ E ] "$@" failed on: "$(OFN_HTM)""

htm: html

html:
	@$(PANDOC) -s -f markdown -t $@ -o $(OFN_HTM) $(IFN_MD) $(NOOUT) $(NOERR) && echo "[ K ] "$@" created successfully: "$(OFN_HTM) || echo "[ E ] "$@" failed on: "$(OFN_HTM)""

# call translation two times for toc
pdf: tex
	@$(PDFTEX) $(TFN_TEX) $(NOOUT) $(NOERR) && echo "[ K ] "$@" created successfully: "$(TFN_TEX) || echo "[ E ] "$@" failed on: "$(TFN_TEX)
	@$(PDFTEX) $(TFN_TEX) $(NOOUT) $(NOERR) && mv $(FN)-wrapper.pdf $(OFN_PDF) && echo "[ K ] "$@" created successfully: "$(OFN_PDF) || echo "[ E ] "$@" failed on: "$(OFN_PDF)

tex:
	@$(PANDOC) -f markdown -t latex -o $(OFN_TEX) $(IFN_MD) && echo "[ K ] "$@" created successfully: "$(OFN_TEX) || echo "[ E ] "$@" failed creation on: "$(OFN_TEX)""
	@$(SED) -i 's/\includegraphics/\scalegraphics/g' $(OFN_TEX) $(NOOUT) $(NOERR) && echo "[ K ] "$@" substituted includegraphics successfully: "$(OFN_TEX) || echo "[ E ] "$@" failed substitution on: "$(OFN_TEX)""

# odt opens in libre office with message: "error reading file" due to old pandoc version (1.11.1)
# works with e.g. 1.15.1
odt:
	$(PANDOC) -s -f markdown -t odt -o $(OFN_ODT) $(IFN_MD) $(NOOUT) $(NOERR) && echo "[ K ] "$@" substituted includegraphics successfully: "$(OFN_ODT) || echo "[ E ] "$@" failed substitution on: "$(OFN_ODT)""

#delete targets
clean:
	@rm -f $(OFN_TEX) $(NOOUT) $(NOERR) || true 
	@rm -f $(OFN_HTM) $(NOOUT) $(NOERR) || true
	@rm -f $(OFN_ODT) $(NOOUT) $(NOERR) || true
	@rm -f $(FN).pdf $(NOOUT) $(NOERR) || true
	@rm -f $(OFN_LOG) $(NOOUT) $(NOERR) || true 
	@rm -f *.aux *.toc || true 

#delete intermediate files
cleanall: clean
	@rm -f *.aux >/dev/null 2>&1 || true
	@rm -f *.out >/dev/null 2>&1 || true
	@rm -f *.log >/dev/null 2>&1 || true
