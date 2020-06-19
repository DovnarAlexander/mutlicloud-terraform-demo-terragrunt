#!/bin/bash

cd $GOPATH/bin
wget https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
unzip terraform_0.12.25_linux_amd64.zip
terraform_0.12.25_linux_amd64.zip
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.18/terragrunt_linux_amd64
mv terragrunt_linux_amd64 terragrunt
chmod +x terragrunt terraform
