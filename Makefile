#=========================================================================
# Builders and flags:

LATEX = latex
BIBTEX = bibtex
PDFLATEX = pdflatex
DVIPS = dvips

RM = rm -f
MV = mv


#=========================================================================
# Files:

MAINSRCS = ids-internals

LOGFILES = $(addsuffix .log, $(MAINSRCS)) $(addsuffix .blg, $(MAINSRCS))
AUXFILES = $(addsuffix .aux, $(MAINSRCS)) $(addsuffix .bbl, $(MAINSRCS)) \
	   $(addsuffix .toc, $(MAINSRCS))
RESFILES = $(addsuffix .dvi, $(MAINSRCS)) $(addsuffix .pdf, $(MAINSRCS)) \
	   $(addsuffix .ps, $(MAINSRCS))

BIBFILES = 

#=========================================================================
# Maintargets:

# ids-internals: Shortcut for ids-internals.pdf
ids-internals: ids-internals.pdf

# epsimg: EPS files used in figures
epsimg:
	$(MAKE) -C ../Abbildungen epsimg

# pdfimg: PDF files used in figures
pdfimg:
	$(MAKE) -C ../Abbildungen pdfimg

# clean: Remove temporary files
clean:
	$(MAKE) -C ../Abbildungen clean
	$(RM) $(LOGFILES)

# clean: Remove all intermediate files
realclean:
	$(MAKE) -C ../Abbildungen realclean
	$(RM) $(AUXFILES) .revision $(LOGFILES)

# clean: Remove all automatically created files
distclean:
	$(MAKE) -C ../Abbildungen distclean
	$(RM) $(RESFILES) $(AUXFILES) .revision $(LOGFILES)

# revfile: Create a file containing the svn version of the curren working dir
revfile:
	svnversion .. > .revision

# Tell make, that the main targets are not actually files, that should
# considered to be build:
.PHONY: all ids-internals \
	final epsimg pdfimg clean realclean distclean revfile


#=========================================================================
# Implicit rules:

.SUFFIXES:
.SUFFIXES: .tex .dvi .ps .pdf

%.dvi: %.tex
	while true; do \
	  $(LATEX) $*; \
	  grep -s 'Rerun to get cross-references right.' $*.log || break; \
	done

%.bbl:
	$(LATEX) $*
	$(BIBTEX) $*

%.pdf: %.tex
	while true; do \
	  $(PDFLATEX) $*; \
	  grep -s 'Rerun to get cross-references right.' $*.log || break; \
	done

%.ps: %.dvi
	$(DVIPS) -o $@ $<


#=========================================================================
# Dependencies:

ids-internals.dvi: revfile ids-internals.tex
ids-internals.pdf: revfile ids-internals.tex
