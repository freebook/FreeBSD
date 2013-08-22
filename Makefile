XSLTPROC = /usr/bin/xsltproc
DSSSL = /home/neo/workspace/Document/Docbook/docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp ebook.$html.XXXXXX)
DOCBOOK=/home/neo/workspace/Document/Docbook
PUBLIC_HTML=/home/neo/workspace/public_html

define reset
	@mkdir -p ${PUBLIC_HTML}/$(1)
	@find ${PUBLIC_HTML}/$(1) -type f -iname "*.html" -exec rm -rf {} \;
endef

define book
	@rsync -au $(DOCBOOK)/common/docbook.css $(PUBLIC_HTML)/$(2)/
	@$(XSLTPROC) -o $(PUBLIC_HTML)/$(2)/ $(DSSSL) $(DOCBOOK)/$(1)/book.xml
	@$(shell test -d $(PUBLIC_HTML)/$(2)/images && find $(PUBLIC_HTML)/$(2)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d $(DOCBOOK)/$(1)/images && rsync -au --exclude=.svn $(DOCBOOK)/$(1)/images $(PUBLIC_HTML)/$(2)/)
endef

all: freebsd

freebsd: 
	@XSLTPROC="xsltproc \
		--stringparam html.stylesheet docbook.css \
		--stringparam use.id.as.filename 1 \
		--stringparam toc.section.depth 5 \
		--stringparam section.autolabel 1 \
		--stringparam css.decoration 1 \
	"
	@cp docbook.css ${PUBLIC_HTML}/$@/
		
	@$(XSLTPROC) -o $(PUBLIC_HTML)/$@/ $(DSSSL) book.xml

show:
	@echo $(DOCBOOK)
	@echo ${PUBLIC_HTML}
	@echo $(TMPDIR)
	@cat Makefile | egrep -o "(.+):" | sed 's/://'
	
clean:
	@rm -rf $(PUBLIC_HTML)/$@


