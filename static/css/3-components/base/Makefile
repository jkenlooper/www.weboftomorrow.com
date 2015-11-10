# A generic Makefile to run the `npm install` command.

# Also some helpful development setup with livereload and such to automate
# things.

npmprerequisites := $(shell npm run npm-prerequisites > /dev/null && cat .npm-prerequisites)

all : .npm-target .livereload
.PHONY : all

.npm-target : $(npmprerequisites) package.json
	npm install;
	@touch .npm-target;

.livereload : .npm-target test/index.html
	touch .livereload;
