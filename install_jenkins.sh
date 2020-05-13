#!/usr/bin/env bash

sudo apt-get update -y

apt-get install -y make

# install tidy
sudo apt-get install -y tidy

# install hadolint
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.6/hadolint-Linux-x86_64
sudo chmod +x /bin/hadolint
