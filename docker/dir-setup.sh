#!/bin/bash

cd ~/
mkdir digix-dao && cd digix-dao

git clone git@github.com:DigixGlobal/dao-contracts.git
cd dao-contracts && git checkout staging-docker && cd ..
git clone git@github.com:DigixGlobal/dao-server.git
cd dao-server && git checkout staging-docker && cd ..
git clone git@github.com:DigixGlobal/info-server.git
cd info-server && git checkout staging-docker && cd ..

mkdir digix-dao-ui && cd digix-dao-ui
git clone git@github.com:DigixGlobal/governance-ui-components.git
cd governance-ui-components && git checkout staging-docker && cd ..
git clone git@github.com:DigixGlobal/governance-ui.git
cd governance-ui && git checkout staging-docker && cd ..
git clone git@github.com:DigixGlobal/react-material-ui-suite.git
cd ..

curl -OL https://gist.githubusercontent.com/roynalnaruto/25ed74dc22aa24960990d83cc80ce6b7/raw/0db4393ad5cea81b0e2bc14bea76decebed9062d/.dockerignore
curl -OL https://gist.githubusercontent.com/roynalnaruto/25ed74dc22aa24960990d83cc80ce6b7/raw/0db4393ad5cea81b0e2bc14bea76decebed9062d/docker-compose.yml
curl -OL https://gist.githubusercontent.com/roynalnaruto/25ed74dc22aa24960990d83cc80ce6b7/raw/0db4393ad5cea81b0e2bc14bea76decebed9062d/Dockerfile.one
curl -OL https://gist.githubusercontent.com/roynalnaruto/25ed74dc22aa24960990d83cc80ce6b7/raw/0db4393ad5cea81b0e2bc14bea76decebed9062d/Dockerfile.two
curl -OL https://gist.githubusercontent.com/roynalnaruto/25ed74dc22aa24960990d83cc80ce6b7/raw/0db4393ad5cea81b0e2bc14bea76decebed9062d/run-server.sh
