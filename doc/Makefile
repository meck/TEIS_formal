# Filter order matters
PANDOCFLAGS :=                                          \
	--from=markdown                                       \
	--wrap=preserve                                       \
	--resource-path="./assets:./images:./"                \
	--metadata-file="./assets/default-metadata.yaml"      \
	--filter pandoc-include-code                          \
	--filter pandoc-crossref                              \
	--citeproc                                            \
	--toc-depth 6                                         \
	--highlight-style tango                               \


PDFFLAGS :=                                             \
	--template="eisvogel.tex"                             \
	--filter pandoc-plot                                  \
	-M plot-configuration="./assets/pandoc-plot-pdf.yml"  \
	--pdf-engine=xelatex                                  \


DOCXFLAGS :=                                            \
	--reference-doc="./assets/custom-reference.docx"      \
	--template="eisvogel.tex"                             \
	--filter pandoc-plot                                  \
	-M plot-configuration="./assets/pandoc-plot-docx.yml" \
	--lua-filter="./assets/pagebreak.lua"                 \

MARKDOWN := $(shell find . -path ./archive -prune -o -iname "*.md")
IMG      := $(wildcard images/*)
BIB      := refs.yaml

PDF  := $(patsubst %.md, output/pdf/%.pdf,$(MARKDOWN))
DOCX := $(patsubst %.md, output/docx/%.docx,$(MARKDOWN))

all: $(PDF) $(DOCX)

pdf: $(PDF)

docx: $(DOCX)

output/pdf/%.pdf: %.md Makefile
	@echo building $(@F)
	@mkdir -p $(@D)
	@pandoc -o $@ $< $(PDFFLAGS) $(PANDOCFLAGS)

output/docx/%.docx: %.md Makefile assets/custom-reference.docx
	@echo building $(@F)
	@mkdir -p $(@D)
	@pandoc -o $@ $< $(DOCXFLAGS) $(PANDOCFLAGS)

clean:
	@rm -rf output

.PHONY: all clean pdf docx
