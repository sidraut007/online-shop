#!/bin/bash

# Docker Installation
function docker_installation() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or use sudo"
        exit 1
    fi

    # Updating Packages and Installing Dependicies
    sudo apt-get update
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Downloading Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    echo "Docker installation completed successfully"
}

function docker_compose_installation() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or use sudo"
        exit 1
    fi

    # Downloading Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    echo "Docker Compose installation completed successfully"
}

docker_installation
docker_compose_installation