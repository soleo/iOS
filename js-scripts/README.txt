
# Execute this file using bash, or run each command in turn:

git clone git@github.com:duckduckgo/abp-filter-parser.git

cd abp-filter-parser

npm install --save-dev webpack

npm install

./node_modules/.bin/webpack --config ../webpack.config.js

