# docker remove #
#!/bin/sh

# Remove all stopped containers

docker rm $(docker ps -a -q)

