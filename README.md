# A Docker image to run Capistrano

Go to [Capistrano](https://github.com/capistrano/capistrano#readme) at GitHub or on their [website](https://capistranorb.com/)

You can find the image on [Docker Hub](https://hub.docker.com/r/botsudo/capistrano)

[![Docker Pulls](https://img.shields.io/docker/pulls/botsudo/capistrano.svg)](https://hub.docker.com/r/botsudo/capistrano)

## How to use it

### Folder and file structure

```tree
./deploy
├── Capfile
├── config
│   ├── deploy-server1
│   │   ├── production.rb
│   │   └── staging.rb
│   ├── deploy-server2
│   │   ├── production.rb
│   │   └── staging.rb
│   └── deploy.rb
├── launch.sh

3 directories, 7 files
```

#### `launch.sh`

```sh
#!/bin/sh -eu

echo "Start SSH agent"
eval $(ssh-agent -s)
ssh-add $SSH_KEY
ssh-add -l

echo "Deploying ($BRANCH) ..."
bundle exec cap $ENV_NAME deploy BRANCH="$BRANCH" SSH_KEY="$SSH_KEY"
```

### Command line

```sh
# For Capistrano logs (https://capistranorb.com/documentation/getting-started/configuration/) LOGNAME and USERNAME are needed

# Example: ./deploy/config/deploy-server1

docker run \

    # Mount some files and folders referenced in .rb configs
    -v /root/deploy/composer.lock:/deploy/composer.lock:rw \
    -v /root/deploy/envs:/deploy/envs:ro \
    -v /root/deploy/keys:/deploy/keys:ro \

    # Mount configs
    -v /root/deploy/config/deploy-server1:/deploy/config/deploy:ro \
    -v /root/deploy/config/deploy.rb:/deploy/config/deploy.rb:ro \

    # Mount your Capfile
    -v /root/deploy/Capfile:/deploy/Capfile:ro \

    # Your script to launch the deploy
    -v /root/deploy/launch.sh:/deploy/scripts/launch.sh:ro \

    # Needed ENVs
    -e LOGNAME="$USER" \
    -e USERNAME="$USER" \
    -e BRANCH=$2 \
    -e ENV_NAME=$ENV_NAME \
    -e SSH_KEY="./deploy/keys/id_rsa_deploy" \
    -it --net=host --rm botsudo/capistrano:3.17.1-symfony sh -exu -c './deploy/scripts/launch.sh'
```
