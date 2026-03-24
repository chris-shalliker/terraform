locals {
  resource_name                  = trimsuffix(var.resource_group_name, "-rg")
  gateway_name                   = "${local.resource_name}-appgw"
  backend_address_pool_name      = "${local.resource_name}-beap"
  frontend_http_port_name        = "${local.resource_name}-http-feport"
  frontend_https_port_name       = "${local.resource_name}-https-feport"
  frontend_ip_configuration_name = "${local.resource_name}-feip"
  http_setting_name              = "${local.resource_name}-be-htst"
  http_listener_name             = "${local.resource_name}-httplstn"
  https_listener_name            = "${local.resource_name}-httpslstn"
  request_routing_rule_name      = "${local.resource_name}-rqrt"
  redirect_configuration_name    = "${local.resource_name}-rdrcfg"
  tfe_vm_nic_name                = "${local.resource_name}-tfe-nic"
  tfe_vm_pip_name                = "${local.resource_name}-tfe-pip"
  tfe_vm_name                    = "${local.resource_name}-tfe-vm"
  tfe_gw_pip_name                = "${local.resource_name}-appgw-pip"
}


