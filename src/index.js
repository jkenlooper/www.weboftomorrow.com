/*
Export for use in the webpack.config.js entry configuration.
These are the entry bundles for specific layouts of the site.
*/

module.exports = {
  homepage: './src/homepage/index.js',
  document: './src/document/index.js',
  documentlistpage: './src/documentlistpage/index.js',
  print: './src/print.js'
  // Other pages would go here
  // other: './src/other.js',
}
