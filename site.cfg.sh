#!/usr/bin/env bash

set -eu -o pipefail

ENVIRONMENT=$1
DATABASEDIR=$2
PORTREGISTRY=$3

# shellcheck source=/dev/null
source "$PORTREGISTRY"

# The .env file has some environment variables that can be added if the app
# requires them. Add this .env file and update the setting of the environment
# variables at the bottom of this file.
if test -e .env; then
  source .env;
fi

if test "$ENVIRONMENT" == 'development'; then
  HOSTNAME="'local-www.weboftomorrow.com'"
  DEBUG=True
else
  HOSTNAME="'www.weboftomorrow.com'"
  DEBUG=False
fi

cat <<HERE

# The site.cfg file is used to configure a flask app.  Refer to the flask
# documentation for other configurations.  The below are used specifically by
# Chill.

# Set the HOST to 0.0.0.0 for being an externally visible server.
HOST = '127.0.0.1'
HOSTNAME = $HOSTNAME
SITE_PROTOCOL = 'http'
PORT = $PORTCHILL
PORTAPI = $PORTAPI

# Valid SQLite URL forms are:
#   sqlite:///:memory: (or, sqlite://)
#   sqlite:///relative/path/to/file.db
#   sqlite:////absolute/path/to/file.db
# http://docs.sqlalchemy.org/en/latest/core/engines.html
CHILL_DATABASE_URI = "sqlite:///${DATABASEDIR}db"

# If using the ROOT_FOLDER then you will need to set the PUBLIC_URL_PREFIX to
# something other than '/'.
#PUBLIC_URL_PREFIX = "/"

# If setting the ROOT_FOLDER:
#PUBLIC_URL_PREFIX = "/site"

# The ROOT_FOLDER is used to send static files from the '/' route.  This will
# conflict with the default value for PUBLIC_URL_PREFIX. Any file or directory
# within the ROOT_FOLDER will be accessible from '/'.  The default is not
# having anything set.
#ROOT_FOLDER = "root"

# The document folder is an optional way of storing content outside of the
# database.  It is used with the custom filter 'readfile' which can read the
# file from the document folder into the template.  If it is a Markdown file
# you can also use another filter to parse the markdown into HTML with the
# 'markdown' filter. For example:


# {{ 'llamas-are-cool.md'|readfile|markdown }}
DOCUMENT_FOLDER = "documents"

# The media folder is used to send static files that are not related to the
# 'theme' of a site.  This usually includes images and videos that are better
# served from the file system instead of the database. The default is not
# having this set to anything.
MEDIA_FOLDER = "media"

# The media path is where the files in the media folder will be accessible.  In
# templates you can use the custom variable: 'media_path' which will have this
# value.
# {{ media_path }}llama.jpg
# or:
# {{ url_for('send_media_file', filename='llama.jpg') }}
MEDIA_PATH = "/media/"

# When creating a stand-alone static website the files in the MEDIA_FOLDER are
# only included if they are linked to from a page.  Set this to True if all the
# files in the media folder should be included in the FREEZER_DESTINATION.
MEDIA_FREEZE_ALL = True

# The theme is where all the front end resources like css, js, graphics and
# such that make up the theme of a website. The THEME_STATIC_FOLDER is where
# these files are located and by default nothing is set here.
THEME_STATIC_FOLDER = "dist"

# Set a THEME_STATIC_PATH for routing the theme static files with.  It's useful
# to set a version number within this path to easily do cache-busting.  In your
# templates you can use the custom variable:
# {{ theme_static_path }}llama.css
# or:
# {{ url_for('send_theme_file', filename='llama.css') }}
# to get the url to a file in the theme static folder.
#THEME_STATIC_PATH = "/theme/v0.0.1/"
import json
VERSION = json.load(open('package.json'))['version']
THEME_STATIC_PATH = "/theme/{0}/".format(VERSION or '0')


# Where the jinja2 templates for the site are located.  Will default to the app
# template_folder if not set.
THEME_TEMPLATE_FOLDER = "templates"

# Where all the custom SQL queries and such are located.  Chill uses a few
# built-in ones and they can be overridden by adding a file with the same name
# in here. To do much of anything with Chill you will need to add some custom
# SQL queries and such to load data into your templates.
THEME_SQL_FOLDER = "queries"

# Helpful to have this set to True if you want to fix stuff.
DEBUG=$DEBUG

# Caching with Flask-Cache
CACHE_NO_NULL_WARNING = True
CACHE_TYPE = "null"
#CACHE_TYPE = "simple"
#CACHE_TYPE = "filesystem"

# https://pythonhosted.org/Frozen-Flask/#configuration
# For creating a stand-alone static website that you can upload without
# requiring an app to run it. This will use Frozen-Flask.
# The path to the static/frozen website will be put.
FREEZER_DESTINATION = "frozen"
FREEZER_BASE_URL = "{0}://{1}/".format(SITE_PROTOCOL, HOSTNAME)

HERE

if test -e .env; then
cat <<HERE
# The environment vars are set in the .env file.  Since site.cfg is generated in
# the environment, the variables can be set here and not use python to inject
# them via os.getenv

# TODO: Replace examples with actual environment vars.
EXAMPLE_PUBLIC_KEY = "${EXAMPLE_PUBLIC_KEY}"
EXAMPLE_SECRET_KEY = "${EXAMPLE_SECRET_KEY}"
HERE
fi
