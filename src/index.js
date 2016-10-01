/*
Export for use in the webpack.config.js entry configuration.
These are the entry bundles for specific layouts of the site.
*/

module.exports = {
  all: './src/all/index.js',
  print: './src/print/index.js',
  homepage: './src/homepage/index.js',
  document: './src/document/index.js',
  documentlistpage: './src/documentlistpage/index.js'
  // At the moment none of these pages require any javascript
}
