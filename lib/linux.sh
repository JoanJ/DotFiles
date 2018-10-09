#!/bin/bash

function install_linux_packages() {

  local package=$1
  cd ~

  if [[ $package ]]; then
    # Install specific package
    echo $package
    $package
  else
    # Install packages
    apt_repositories
    common
    ansible
    vscode
    node
    serverless
    terraform
    docker
    teamviewer
  fi

}

# APT repositories
function apt_repositories() {

  # Common packages
  sudo apt-get install -y gcc g++ make wget curl software-properties-common

  # Google Chrome
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

  # VS Code
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  
  # Yarn
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  # Node 8
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

  # Ansible
  sudo apt-add-repository -y ppa:ansible/ansible

  # Docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

}

# Common
function common() {

  sudo apt update
  sudo apt-get install -y git gcc g++ make curl python2
  sudo apt-get update
  sudo apt-get install software-properties-common
  sudo apt-add-repository --yes --update ppa:ansible/ansible
  sudo apt-get install ansible

}

# Puppet
function ansible() {

  ansible-playbook /pathTO/DotFiles/ansible/playbook.yml --connection=local

}

# AWS

# VS Code
function vscode() {

  cat /pathTO/DotFiles/extensions.txt | xargs -L 1 code-insiders --install-extension
  
}

# Node
function node() {

  # NPM
  sudo npm install -g npm@latest
  echo "alias node='nodejs'" >>  ~/.bashrc
  source ~/.bashrc

}

# Serverless
function serverless() {

  sudo npm install serverless -g
  # serverless update check failed
  sudo chown -R $USER:$(id -gn $USER) ~/.config

}

# Terraform
function terraform() {

  URL="https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip"
  curl -s $URL > /tmp/terraform.zip
  sudo unzip -o /tmp/terraform.zip -d /usr/local/bin/
  rm -f /tmp/terraform.zip

}

# Docker
function docker() {

  # Fix docker right
  sudo usermod -aG docker $USER

  # Install docker-compose
  sudo curl -sL https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

}

function teamviewer() {

  wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
  sudo apt-get install ./teamviewer_amd64.deb
}