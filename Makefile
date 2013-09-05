XSLTPROC = /usr/bin/xsltproc
DSSSL = ../docbook-xsl/docbook.xsl
TMPDIR = $(shell mktemp -d --suffix=.tmp -p /tmp ebook.$html.XXXXXX)
WORKSPACE=~/workspace
PROJECT=FreeBSD
DOCBOOK=freebsd
PUBLIC_HTML=~/public_html
HTML=$(PUBLIC_HTML)/$(DOCBOOK)
HTMLHELP=$(PUBLIC_HTML)/htmlhelp/${DOCBOOK}/chm

all: html htmlhelp

html: 
	@XSLTPROC="xsltproc \
		--stringparam html.stylesheet docbook.css \
		--stringparam use.id.as.filename 1 \
		--stringparam toc.section.depth 5 \
		--stringparam section.autolabel 1 \
		--stringparam css.decoration 1 \
	"
	@cp docbook.css ${PUBLIC_HTML}/$(DOCBOOK)/
		
	@$(XSLTPROC) -o $(HTML)/ $(DSSSL) book.xml
	@$(shell test -d $(HTML)/images && find $(HTML)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d images && rsync -au --exclude=.svn images $(HTML)/)

htmlhelp:
	${XSLTPROC} -o $(HTMLHELP)/ --stringparam htmlhelp.chm ../$(PROJECT).chm ../docbook-xsl/htmlhelp/template.xsl $(WORKSPACE)/${PROJECT}/book.xml
	@../common/chm.sh $(HTMLHELP)
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/htmlhelp.hhp < $(HTMLHELP)/htmlhelp.hhp
	@iconv -f UTF-8 -t GB18030 -o $(HTMLHELP)/toc.hhc < $(HTMLHELP)/toc.hhc
	@$(shell test -d $(HTMLHELP)/images && find $(HTMLHELP)/images/ -type f -exec rm -rf {} \;)
	@$(shell test -d images && rsync -au --exclude=.svn images $(HTMLHELP)/)
	@cp $(PUBLIC_HTML)/images/by-nc-sa.png $(HTMLHELP)/images

show:
	@echo $(DOCBOOK)
	@echo ${PUBLIC_HTML}
	@echo $(TMPDIR)
	@cat Makefile | egrep -o "(.+):" | sed 's/://'
	
clean:
	@rm -rf $(PUBLIC_HTML)/$@


