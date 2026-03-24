# Terraform TFE Deployment

Stuart Galloway 18/01/2021

## Purpose

Used to deploy Terraform Enterprise 

## Actions

- Deploys the following
  - Network
  - PIP
  - Linux CentOS VM
  - Terrafrom TFE using the `Replicated` container deployment mechanism

## Output

- Azure Resource Group populated with a Dockerised TFE instance running in a Linux VM behind an application gateway

## Required Changes

- Change the variables in `terraform.tfvars` particularly the `resource_name` variable to enable the creation of a unique TFE deployment
- Change the key in `terraform.tf` to give yourself a unique Azure backend for state storage