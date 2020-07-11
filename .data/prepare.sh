#!/bin/bash

BIN=$HOME/.local/bin
mkdir -p $BIN

wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
unzip terraform_0.12.28_linux_amd64.zip
chmod u+x terraform
mv terraform $BIN/terraform

wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.31/terragrunt_linux_amd64
chmod u+x terragrunt_linux_amd64
mv terragrunt_linux_amd64 $BIN/terragrunt
