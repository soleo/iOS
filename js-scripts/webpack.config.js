
module.exports = {
  entry: './src/abp-filter-parser.js',
  output: {
    filename: 'abp-filter-parser-packed.js',
    path: __dirname + '/build'
  },
  node: {
    fs: 'empty'
  }
};

