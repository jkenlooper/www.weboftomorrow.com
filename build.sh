#!/bin/bash

# Build script to compile the static resources into the dist/ directory.

# lint individual css files
postcss \
    -u postcss-bem-linter \
    -u postcss-reporter \
    -d /dev/null \
    static/css/*.css 2> /dev/null;

# cleanup dist/css
rm -rf dist/css;

# build a dist/css
mkdir -p dist/css;
postcss -c postcss.json \
    -d dist/css \
    -u postcss-import \
    -u postcss-custom-properties \
    -u postcss-custom-media \
    -u postcss-calc \
    -u autoprefixer \
    -u postcss-url \
    -u cssnano \
    -u postcss-reporter \
    static/css/site.css \
    static/css/developer.css \
    2> /dev/null;
