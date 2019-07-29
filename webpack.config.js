const webpack = require("webpack");
const path = require("path");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require("terser-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const postcssImport = require("postcss-import");
const postcssURL = require("postcss-url");
const postcssPresetEnv = require("postcss-preset-env");
const postcssCustomMedia = require("postcss-custom-media");

const srcEntry = require("./src/index.js");

process.traceDeprecation = true;

/**
 * Config
 * Reference: http://webpack.github.io/docs/configuration.html
 * This is the object where all configuration gets set
 */
const config = {};

config.mode = "development";

config.bail = true;

/**
 * Entry
 * Reference: http://webpack.github.io/docs/configuration.html#entry
 */
config.entry = srcEntry;

/**
 * Output
 * Reference: http://webpack.github.io/docs/configuration.html#output
 */
config.output = {
  path: path.resolve(__dirname, "dist"),
  filename: "[name].bundle.js"
};

config.resolve = {
  extensions: [".ts", ".js"],
  modules: ["src", "node_modules"]
};

config.module = {
  rules: [
    {
      test: /\.ts$/,
      exclude: /node_modules/,
      use: {
        loader: "ts-loader"
      }
    },
    {
      test: /_fonts\/.*\.(eot|svg|ttf|woff)/,
      use: [
        {
          loader: "file-loader",
          options: { name: "[name].[ext]" }
        }
      ],
      exclude: /node_modules/
    },
    {
      test: /\.(png|gif|jpg)$/,
      use: [
        {
          loader: "file-loader",
          options: { name: "[name].[ext]" }
        }
      ],
      exclude: /node_modules/
    },
    {
      test: /\.css$/,
      use: [
        MiniCssExtractPlugin.loader,
        { loader: "css-loader", options: { importLoaders: 1 } },
        {
          loader: "postcss-loader",
          options: {
            ident: "postcss",
            plugins: loader => [
              postcssImport({ root: loader.resourcePath }),
              postcssURL(),
              postcssCustomMedia(),
              postcssPresetEnv()
            ]
          }
        }
      ]
    },
    {
      test: /\.svg$/,
      use: [
        {
          loader: "file-loader",
          options: {
            name: "[name].[ext]"
          }
        },
        "svgo-loader"
      ],
      exclude: /(node_modules|_fonts)/
    },
    {
      test: /\.html$/,
      use: "raw-loader"
    }
  ]
};

config.plugins = [
  new CleanWebpackPlugin(),
  new MiniCssExtractPlugin({ filename: "[name].css" })
];

config.stats = "minimal";

config.optimization = {
  minimizer: [
    new TerserPlugin({
      cache: true,
      parallel: true,
      sourceMap: true, // set to true if you want JS source maps
      terserOptions: {
        compress: {
          drop_console: true
        }
      }
    }),
    new OptimizeCSSAssetsPlugin({})
  ]
};

config.performance = {
  hints: "warning"
  //maxAssetSize: 500000,
  //maxEntrypointSize: 800000,
};

module.exports = (env, argv) => {
  if (argv.mode !== "production") {
    config.devtool = "source-map";
    config.watch = argv.watch;
    config.watchOptions = {
      aggregateTimeout: 300,
      poll: 1000
    };
    config.optimization = {};
  }

  return config;
};
