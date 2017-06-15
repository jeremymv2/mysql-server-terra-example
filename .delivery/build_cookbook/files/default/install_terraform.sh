#!/bin/bash

if [ ! -d "$HOME/tools/terraform-0.9.8" ]; then
  mkdir -p $HOME/tools/terraform-0.9.8
  cd $HOME/tools || exit
  curl -sLo terraform.zip https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip
  unzip terraform.zip
  rm -f terraform.zip || true
  mv terraform terraform-0.9.8
fi

echo "terraform --version"
$HOME/tools/terraform-0.9.8/terraform --version
