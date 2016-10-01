# Front End Resources

The `index.js` file is used by webpack.config.js for the webpack entry setting.

The `all/index.js` entry imports `all/all.css` which imports a cascade of other
CSS files.  The theory is to match how the templates extend and import other
templates.
