# Set up all systems for DigixDAO platform's development on local machine

### To be done once
* Open `~/.ipfs/config` and change the `API` and `Addresses` objects to this:
```
"API": {
    "HTTPHeaders": {   
      "Access-Control-Allow-Methods": [
        "PUT",
        "GET",
        "POST"
      ],
      "Access-Control-Allow-Origin": [
        "*"
      ]
    }
  },
  "Addresses": {
    "API": "/ip4/127.0.0.1/tcp/5001",
    "Announce": [],
    "Gateway": "/ip4/0.0.0.0/tcp/9001",
    "NoAnnounce": [],
    "Swarm": [
      "/ip4/0.0.0.0/tcp/4001",
      "/ip6/::/tcp/4001"
    ]
  },
```

* clone all these repositories in the same folder:
  * `governance-ui`
  * `governance-ui-components`
  * `react-material-ui-suite`
  * `info-server`
  * `dao-server`
  * `dao-contracts`

* Install `react-material-ui-suite`:
```
cd react-material-ui-suite
rm -rf package-lock.json
rm -rf node_modules
npm i
```

### To update new changes, setup and start the servers:
(All these scripts are in `dao-server` repo, `dev` branch)
##### A. Whenever you want to pull latest changes from all the repositories:
```
bash scripts/pull.sh
```
* Please note that, the branches for the repositories are as followed:
    * `governance-ui`: `develop`
    * `governance-ui-components`: `develop`
    * `dao-server`: `dev`
    * `info-server`: `dev`
    * `dao-contracts`: `dev`

##### B. Whenever you want to setup or re-setup the repositories:
```
bash scripts/setup.sh
```
  * This will re-setup the repositories (remove `node_modules`, `package-lock.json`, recompiling contracts ,...)
  * To be done when you think someone has update some repositories that require installing some new dependencies
  * if you want to skip the setup of some repositories, you can specify them as such:
  ```
  <SKIP_UI_COMPONENTS=true> <SKIP_UI=true> <SKIP_INFO_SERVER=true> <SKIP_DAO_CONTRACTS=true> <SKIP_DAO_SERVER=true> bash scripts/setup.sh
  ```

##### C. Whenever you want to start/restart the whole local system:
```
bash scripts/restart.sh
```
This will:
  * redeploy a new DigixDAO instance
  * Reset the database and restart `dao-sever`
  * Restart `info-server`
  * Restart `spectrum` for the UI
  * if you want to skip the restart of some servers, you can specify them as such:
  ```
  <SKIP_UI=true> <SKIP_INFO_SERVER=true> <SKIP_DAO_CONTRACTS=true> <SKIP_DAO_SERVER=true> bash scripts/restart.sh
  ```
