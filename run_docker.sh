#!/usr/bin/env bash

# delete previous image
#docker image rm udcapstone-cicd

# Build image and add a descriptive tag
docker build --tag="udcapstone-cicd" .

# List docker images
docker image ls

# Start up the webserver in the container
docker run -it -p 80:80 --rm --name udcapscont "udcapstone-cicd" 

# To run the base container for development:
# docker run -it -p 80:80 --rm --name nginxcont "nginx:stable"
nginx -c /etc/nginx/nginx.conf