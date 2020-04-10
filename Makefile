MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir := $(dir $(mkfile_path))

# Local pip is used by creating virtualenv and running `source ./bin/activate`

# Set to tmp/ when debugging the install
# make PREFIXDIR=${PWD}/tmp inspect.SRVDIR
# make PREFIXDIR=${PWD}/tmp ENVIRONMENT=development install
PREFIXDIR :=

# Set to development or production
ENVIRONMENT := development

PORTREGISTRY := ${PWD}/port-registry.cfg
SRVDIR := $(PREFIXDIR)/srv/www.weboftomorrow.com/
NGINXDIR := $(PREFIXDIR)/etc/nginx/
SYSTEMDDIR := $(PREFIXDIR)/etc/systemd/system/
DATABASEDIR := $(PREFIXDIR)/var/lib/www.weboftomorrow.com/sqlite3/
NGINXLOGDIR := $(PREFIXDIR)/var/log/nginx/www.weboftomorrow.com/

# Set the internal ip which is used to secure access to admin/ pages.
INTERNALIP := $(shell hostname -I | cut -d' ' -f1)

# Get the version from the package.json
TAG := $(shell cat package.json | python -c 'import sys, json; print(json.load(sys.stdin)["version"])')

# For debugging what is set in variables
inspect.%:
	@echo $($*)

ifeq ($(shell which virtualenv),)
$(error run "./bin/setup.sh" to install virtualenv)
endif
ifeq ($(shell ls bin/activate),)
$(error run "virtualenv . -p python3")
endif
ifneq ($(shell which pip),$(project_dir)bin/pip)
$(warning run "source bin/activate" to activate the virtualenv. Using $(shell which pip). Ignore this warning if using sudo make install.)
endif


# Always run.  Useful when target is like targetname.% .
# Use $* to get the stem
FORCE:

objects := site.cfg web/www.weboftomorrow.com.conf web/www.weboftomorrow.com--down.conf


#####

# Uncomment if this is needed in the ssl setup
#web/dhparam.pem:
	#openssl dhparam -out $@ 2048

bin/chill: chill/requirements.txt requirements.txt
	pip install --upgrade --upgrade-strategy eager -r $<
	touch $@;

objects += chill/www.weboftomorrow.com-chill.service
chill/www.weboftomorrow.com-chill.service: chill/www.weboftomorrow.com-chill.service.sh
	./$< $(ENVIRONMENT) $(project_dir) > $@

# Create a tar of the frozen directory to prevent manually updating files within it.
objects += frozen.tar.gz
frozen.tar.gz: db.dump.sql site.cfg package.json $(shell find templates/ -type f -print) $(shell find documents/ -type f -print) $(shell find queries/ -type f -print)
	bin/freeze.sh $@

objects += db.dump.sql
# Create db.dump.sql from site-data.sql and any chill-*.yaml files
db.dump.sql: site.cfg site-data.sql $(wildcard chill-*.yaml)
	bin/create-db-dump-sql.sh

site.cfg: site.cfg.sh $(PORTREGISTRY)
	./$< $(ENVIRONMENT) $(DATABASEDIR) $(PORTREGISTRY) > $@

web/www.weboftomorrow.com.conf: web/www.weboftomorrow.com.conf.sh $(PORTREGISTRY)
	./$< $(ENVIRONMENT) $(SRVDIR) $(NGINXLOGDIR) $(PORTREGISTRY) $(INTERNALIP) > $@
web/www.weboftomorrow.com--down.conf: web/www.weboftomorrow.com--down.conf.sh $(PORTREGISTRY)
	./$< $(ENVIRONMENT) $(SRVDIR) $(NGINXLOGDIR) $(PORTREGISTRY) $(INTERNALIP) > $@

# Uncomment if using dhparam.pem
#ifeq ($(ENVIRONMENT),production)
## Only create the dhparam.pem if needed.
#objects += web/dhparam.pem
#web/www.weboftomorrow.com.conf: web/dhparam.pem
#endif

.PHONY: www.weboftomorrow.com-$(TAG).tar.gz
www.weboftomorrow.com-$(TAG).tar.gz: bin/dist.sh
	./$< $(abspath $@)

######

.PHONY: all
all: bin/chill media $(objects)

.PHONY: install
install:
	./bin/install.sh $(SRVDIR) $(NGINXDIR) $(NGINXLOGDIR) $(SYSTEMDDIR) $(DATABASEDIR)

.PHONY: deploy
deploy:
ifeq ($(ENVIRONMENT),production)
	./bin/deploy.sh
else
	./bin/deploy.sh --dryrun
endif

# Remove any created files in the src directory which were created by the
# `make all` recipe.
.PHONY: clean
clean:
	rm $(objects)
	echo $(objects) | xargs rm -f
	pip uninstall --yes -r chill/requirements.txt
	for mk in $(source_media_mk); do make -f $${mk} clean; done;

# Remove files placed outside of src directory and uninstall app.
# Will also remove the sqlite database file.
.PHONY: uninstall
uninstall:
	./bin/uninstall.sh $(SRVDIR) $(NGINXDIR) $(SYSTEMDDIR) $(DATABASEDIR)

.PHONY: dist
dist: www.weboftomorrow.com-$(TAG).tar.gz

# Find any make files in the source-media folder. Sort so the 00_ratio-hint.mk
# is last.
source_media_mk := $(shell find source-media/ -type f -name '*.mk' -print | sort --dictionary-order --ignore-case --reverse)
.PHONY: media
media:
	for mk in $(source_media_mk); do make -f $${mk}; done;
