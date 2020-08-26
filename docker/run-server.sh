#!/bin/bash

cd /usr/src/info-server/
echo "starting info-server"
rm -f out.log
./node_modules/.bin/pm2 start development.config.js

cd /usr/src/ui/governance-ui
echo "starting governance ui"
npm start

cd /usr/src/info-server
tail -f out.log
