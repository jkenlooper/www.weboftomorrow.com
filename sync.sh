#!/bin/bash


# Content for weboftomorrow is in a separate repo.
(cd ../content-weboftomorrow;
# Sync documents and media to build server
rsync --archive --progress --itemize-changes \
  documents \
  media \
  jake@pi:/home/jake/dev/www.weboftomorrow.com/

# Sync built db.dump back to local
rsync --archive --progress --itemize-changes \
  jake@pi:/home/jake/dev/www.weboftomorrow.com/db.dump \
  ./
)

# Sync source files to build server
rsync --archive --progress --itemize-changes \
  .babelrc \
  LICENSE \
  README.md \
  lib \
  package.json \
  queries \
  root \
  site.cfg \
  src \
  templates \
  webpack.config.js \
  jake@pi:/home/jake/dev/www.weboftomorrow.com/

# Sync built files back to local
rsync --archive --progress --itemize-changes \
  --delete-after \
  jake@pi:/home/jake/dev/www.weboftomorrow.com/{dist,node_modules,npm-debug.log} \
  ./

