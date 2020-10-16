# speedtest #
#!/bin/sh

docker pull adolfintel/speedtest:latest
docker stop speedtest
docker rm   speedtest

docker run -d --restart unless-stopped  --restart=unless-stopped --net=net88 --ip=192.168.88.100 --name speedtest adolfintel/speedtest:latest

