# Run as Docker Containers
You can run every required service as docker containers in local machine. Finally, it should run containers for the following images:
* IPFS
* MySQL
* MongoDB
* Ganache
* DAO Server
* Info Server, DAO contracts and Governance UI (all these run in the same container, as they're dependent on DAO contracts)

### Install packages
* docker-ce
```
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install docker-ce
```
**Note:** The above should work for Ubuntu 16.04 and 18.04 LTS
* verify installation by running a test container
```
$ sudo docker run hello-world
```
* docker-compose
```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```
* verify installation by checking the version
```
$ docker-compose --version
```

### Setup
* move to whatever is your base directory (say, its `~/`)
```
$ cd ~/
```
* download the script to setup your directory structure
```
$ curl -OL https://gist.githubusercontent.com/roynalnaruto/25ed74dc22aa24960990d83cc80ce6b7/raw/f672ccde33e57be73783b4179887600d0a4d2cc8/dir-setup.sh
```
**Note:** Alternatively, this file can also be found in the `scripts/docker/` directory
* run the above script that was downloaded
```
$ chmod 777 dir-setup.sh
$ bash dir-setup.sh
```
* verify that the following directory/file structure has been created
```
base-dir
    ├── dir-setup.sh
    └── digix-dao/
          ├── dao-server/
          ├── info-server/
          ├── dao-contracts/
          ├── digix-dao-ui/
          |     ├── governance-ui-components/
          |     ├── governance-ui/
          |     └── react-material-ui-suite/
          ├── run-server.sh
          ├── Dockerfile.one
          ├── Dockerfile.two
          ├── docker-compose.yml
          └── .dockerignore
```

### Run
* build the images (in `~/digix-dao`)
```
$ docker-compose build
```
* start the containers
```
$ docker-compose up
```

### Testing
* The same keystores have been used as the digixdao-kovan [keystores](https://tracker.digixdev.com/_persistent/digixdao-kovan.zip?file=6-181&c=false&updated=0)
    * Password: `digixdao-kovan` (for all keystores)
* Endpoints
    * UI: https://localhost:3000
    * Info-server: http://localhost:3001
    * Dao-server: http://localhost:3005
    * MongoDB: `$ mongo` in terminal should work
    * MySQL: Can be run from the docker container (password `digixtest`)
    ```
    $ docker exec -it CONTAINER-ID /bin/bash

    # mysql -u root -p
    ```
* Logging
    * Dao-server:
    ```
    $ docker logs -f CONTAINER-ID
    ```
    * Info-server:
    ```
    $ docker exec -it CONTAINER-ID /bin/bash
    # tail -f /usr/src/info-server/out.log
    ```
