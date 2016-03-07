var webpack = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var postcssImport = require('postcss-import')
var postcssNested = require('postcss-nested')
var postcssCustomProperties = require('postcss-custom-properties')
var postcssCustomMedia = require('postcss-custom-media')
var postcssCalc = require('postcss-calc')
var postcssUrl = require('postcss-url')
var autoprefixer = require('autoprefixer')
var cssByebye = require('css-byebye')
var cssnano = require('cssnano')
var PRODUCTION = JSON.parse(process.env.NODE_ENV === 'production')

module.exports = {
  entry: {
    // The 'site' entry is basically the 'common' chunk, and is on every page.
    site: './src/site.js',
    print: './src/print.js'
    // Other pages would go here
    // other: './src/other.js',
  },
  output: {
    path: __dirname + '/dist',
    filename: '[name].bundle.js'
  },
  resolve: {
    modulesDirectories: ['src', 'node_modules']
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel'
      },
      {
        test: /fonts\/.*\.(eot|svg|ttf|woff)$/,
        loader: 'file-loader?name=[name].[ext]',
        exclude: /node_modules/
      },
      {
        test: /\.png$/,
        loader: 'file-loader',
        exclude: /node_modules/
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style-loader', 'css-loader!postcss-loader'),
        exclude: /node_modules/
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new ExtractTextPlugin('[name].css', {
      allChunks: true
    })
  ],
  postcss: function (webpack) {
    var use = [
      postcssImport({
        addDependencyTo: webpack
      }),
      postcssNested,
      postcssCustomProperties,
      postcssCustomMedia,
      postcssCalc,
      autoprefixer,
      postcssUrl,
      cssByebye({
        rulesToRemove: [
          ''
        ]
      })
    ]
    if (PRODUCTION) {
      use.push(cssnano({
        safe: true
      }))
    }
    return use
  }
}