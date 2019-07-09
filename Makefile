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
SRVDIR := $(PREFIXDIR)/srv/weboftomorrow/
NGINXDIR := $(PREFIXDIR)/etc/nginx/
SYSTEMDDIR := $(PREFIXDIR)/etc/systemd/system/
DATABASEDIR := $(PREFIXDIR)/var/lib/weboftomorrow/sqlite3/
NGINXLOGDIR := $(PREFIXDIR)/var/log/nginx/weboftomorrow/

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

objects := site.cfg web/weboftomorrow.conf


#####

# Uncomment if this is needed in the ssl setup
#web/dhparam.pem:
	#openssl dhparam -out $@ 2048

bin/chill: chill/requirements.txt requirements.txt
	pip install --upgrade --upgrade-strategy eager -r $<
	touch $@;

objects += chill/weboftomorrow-chill.service
chill/weboftomorrow-chill.service: chill/weboftomorrow-chill.service.sh
	./$< $(ENVIRONMENT) $(project_dir) > $@

# Create a tar of the frozen directory to prevent manually updating files within it.
objects += frozen.tar.gz
frozen.tar.gz: db.dump.sql site.cfg package.json $(shell find templates/ -type f -print) $(shell find documents/ -type f -print) $(shell find queries/ -type f -print)
	bin/freeze.sh $@

# Create db.dump.sql from chill-data.sql and any chill-*.yaml files
db.dump.sql: site.cfg chill-data.sql $(wildcard chill-*.yaml)
	bin/create-db-dump-sql.sh

site.cfg: site.cfg.sh $(PORTREGISTRY)
	./$< $(ENVIRONMENT) $(DATABASEDIR) $(PORTREGISTRY) > $@

web/weboftomorrow.conf: web/weboftomorrow.conf.sh $(PORTREGISTRY)
	./$< $(ENVIRONMENT) $(SRVDIR) $(NGINXLOGDIR) $(PORTREGISTRY) > $@

# Uncomment if using dhparam.pem
#ifeq ($(ENVIRONMENT),production)
## Only create the dhparam.pem if needed.
#objects += web/dhparam.pem
#web/weboftomorrow.conf: web/dhparam.pem
#endif

.PHONY: weboftomorrow-$(TAG).tar.gz
weboftomorrow-$(TAG).tar.gz: bin/dist.sh
	./$< $(abspath $@)

######

.PHONY: all
all: bin/chill $(objects)

.PHONY: install
install:
	./bin/install.sh $(SRVDIR) $(NGINXDIR) $(NGINXLOGDIR) $(SYSTEMDDIR) $(DATABASEDIR)

# Remove any created files in the src directory which were created by the
# `make all` recipe.
.PHONY: clean
clean:
	rm $(objects)
	pip uninstall --yes -r chill/requirements.txt

# Remove files placed outside of src directory and uninstall app.
# Will also remove the sqlite database file.
.PHONY: uninstall
uninstall:
	./bin/uninstall.sh $(SRVDIR) $(NGINXDIR) $(SYSTEMDDIR) $(DATABASEDIR)

.PHONY: dist
dist: weboftomorrow-$(TAG).tar.gz
