#! /bin/bash

cd ../../client/ngQuote/dist
#npm run build
if [[ -e ./client-app.zip ]]; then
    rm ./client-app.zip
fi
zip -q -r ./client-app.zip ./
