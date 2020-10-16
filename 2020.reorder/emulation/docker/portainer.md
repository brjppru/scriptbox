# portainer #
#!/bin/sh

# docker volume create portainer_data

# https://portainer.io/

docker volume create portainer_data

mkdir -p /docker/portainer

docker pull portainer/portainer
docker stop portainer
docker rm portainer

docker run -d -p 9000:9000 --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer:/data --name portainer portainer/portainer
