#! /bin/bash

cd ../../client/ngQuote
npm run build
if [[ -e ./dist/client-app.zip ]]; then
    rm ./dist/client-app.zip
    zip -q -r ./dist/client-app.zip dist
  else
    zip -q -r ./dist/client-app.zip dist
fi
