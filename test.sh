#!/usr/bin/env bash
set -e

image_name=linux-setup
repo_dir="$(cd "$(dirname "$0")" && pwd)"

# ubuntu:latest already ships a non-root "ubuntu" user (uid/gid 1000); just grant it sudo
docker build -t "$image_name" -f - "$repo_dir" <<'EOF'
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y sudo unminimize && \
    rm -rf /var/lib/apt/lists/* && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

RUN DEBIAN_FRONTEND=noninteractive yes | unminimize

USER ubuntu
WORKDIR /home/ubuntu
EOF

docker run -it --rm \
    -e SHELL=/bin/bash \
    -e TERM=xterm-256color \
    -v "${repo_dir}:/home/ubuntu/linux-setup" \
    -w /home/ubuntu/linux-setup \
    -u ubuntu \
    "$image_name" \
    bash
