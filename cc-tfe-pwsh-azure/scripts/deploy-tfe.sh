#!/bin/sh
sudo yum install epel-release -y
sudo yum install git gcc gcc-c++ nodejs gettext device-mapper-persistent-data lvm2 bzip2 python3-pip htop -y
sudo curl -o install.sh https://install.terraform.io/ptfe/stable

# Register the Microsoft RedHat repository
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
# Install PowerShell
sudo yum install -y powershell

# Start PowerShell and run script
sudo pwsh ./tmp/Config-Terraform-Azure.ps1

#Install terraform
sudo bash ./install.sh \
    no-proxy

#Cleanup
sudo rm /tmp/licence.rli
sudo rm /tmp/Config-Terraform-Azure.ps1
sudo rm /tmp/settings.json
sudo rm /tmp/setdata.json
sudo rm /etc/replicated.conf
