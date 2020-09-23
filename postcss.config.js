const postcssImport = require("postcss-import");
const postcssURL = require("postcss-url");
const postcssPresetEnv = require("postcss-preset-env");
const postcssCustomMedia = require("postcss-custom-media");

module.exports = {
  plugins: [
    postcssImport({ root: "src/" }),
    postcssCustomMedia(),
    postcssURL(),
    postcssPresetEnv(),
  ],
};
