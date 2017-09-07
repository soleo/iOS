
# You should start in the same directory as this file when following these instructions from terminal

# Execute:
git clone git@github.com:duckduckgo/abp-filter-parser.git

# Execute:
cd abp-filter-parser

# Exectute each npm install:
npm install --save-dev webpack
npm install babel-cli babel-preset-es2015
npm install

# Edit src/abp-filter.parser.js and add the following line to the top of the file:
import "babel-polyfill";

# Execute to combine all JS in to one script:
./node_modules/.bin/webpack --config ../webpack.config.js

# Execute to transpile the JS in to a backwards compatible version:
./node_modules/babel-cli/bin/babel.js --presets ../abp-filter-parser/node_modules/babel-preset-es2015 ../build/abp-filter-parser-packed.js -o ../build/abp-filter-parser-packed-es2015.js

# Execute to cp the new file to the right location for iOS:
cp ../build/abp-filter-parser-packed-es2015.js ../../Core/abp-filter-parser-packed-es2015.js 

