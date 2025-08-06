locals {
  gateway_host_profiles = {
    10000 = "INTEL_XEON_5218_2_30"
    1000  = "INTEL_XEON_4210_2_20"
  }

  gateway_images = {
    10000 = "OS_VIRTUAL_ROUTER_APPLIANCE_22_X_UP_TO_20_GBPS_SUBSCRIPTION_EDITION_64_BIT"
    1000  = "OS_VIRTUAL_ROUTER_APPLIANCE_22_X_UP_TO_2_GBPS_SUBSCRIPTION_EDITION_64_BIT"
  }

  appliance_types = {
    10000 = "VIRTUAL_ROUTER_APPLIANCE_10_GPBS"
    1000  = "VIRTUAL_ROUTER_APPLIANCE_1_GPBS"
  }

  gateway_public_bandwidth = {
    10000 = "20000"
    1000  = "5000"
  }

  classic_gateway_resource_name = {
    true  = "gateway_ha"
    false = "gateway_single"
  }

  classic_gateway_resource_name_region_2 = {
    true  = "gateway_ha_region_2"
    false = "gateway_single_region_2"
  }

  cos_region = {
    fra02 = "eu-de"
    fra04 = "eu-de"
    fra05 = "eu-de"
    ams03 = "eu-de"
    mil01 = "eu-de"
    par01 = "eu-de"
    mon01 = "ca-tor"
    che01 = "jp-osa"
    sng01 = "jp-osa"
    lon02 = "eu-gb"
    lon04 = "eu-gb"
    lon05 = "eu-gb"
    lon06 = "eu-gb"
    mad02 = "eu-es"
    mad04 = "eu-es"
    mad05 = "eu-es"
    dal09 = "us-south"
    dal10 = "us-south"
    dal12 = "us-south"
    dal13 = "us-south"
    dal14 = "us-south"
    sjc03 = "us-south"
    sjc04 = "us-south"
    wdc04 = "us-east"
    wdc06 = "us-east"
    wdc07 = "us-east"
    syd01 = "au-syd"
    syd04 = "au-syd"
    syd05 = "au-syd"
    tok02 = "jp-tok"
    tok04 = "jp-tok"
    tok05 = "jp-tok"
    osa21 = "jp-osa"
    osa22 = "jp-osa"
    osa23 = "jp-osa"
    tor01 = "ca-tor"
    tor04 = "ca-tor"
    tor05 = "ca-tor"
    sao01 = "br-sao"
    sao04 = "br-sao"
    sao05 = "br-sao"
  }

  vpc_region = {
    eu-de-1    = "eu-de"
    eu-de-2    = "eu-de"
    eu-de-3    = "eu-de"
    eu-gb-1    = "eu-gb"
    eu-gb-2    = "eu-gb"
    eu-gb-3    = "eu-gb"
    eu-gb-4    = "eu-gb"
    eu-es-1    = "eu-es"
    eu-es-2    = "eu-es"
    eu-es-3    = "eu-es"
    us-south-1 = "us-south"
    us-south-2 = "us-south"
    us-south-3 = "us-south"
    ca-tor-1   = "ca-tor"
    ca-tor-2   = "ca-tor"
    ca-tor-3   = "ca-tor"
    ca-mon-1   = "ca-mon"
    ca-mon-2   = "ca-mon"
    ca-mon-3   = "ca-mon"
    br-sao-1   = "br-sao"
    br-sao-2   = "br-sao"
    br-sao-3   = "br-sao"
    us-east-1  = "us-east"
    us-east-2  = "us-east"
    us-east-3  = "us-east"
    au-syd-1   = "au-syd"
    au-syd-2   = "au-syd"
    au-syd-3   = "au-syd"
    jp-tok-1   = "jp-tok"
    jp-tok-2   = "jp-tok"
    jp-tok-3   = "jp-tok"
  }
}

resource "ibm_network_gateway" "gateway_single" {
  name  = var.gateway_name
  count = var.gateway_ha_enabled == false && var.deploy_gateway_appliance == true ? 1 : 0
  members {
    hostname             = var.hostname_gateway_1
    domain               = var.classic_domain
    datacenter           = var.classic_datacenter
    network_speed        = var.gateway_appliance_network_speed
    private_network_only = var.classic_gateway_private_only
    tcp_monitoring       = true
    process_key_name     = lookup(local.gateway_host_profiles, var.gateway_appliance_network_speed)
    os_key_name          = lookup(local.gateway_images, var.gateway_appliance_network_speed)
    package_key_name     = lookup(local.appliance_types, var.gateway_appliance_network_speed)
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = lookup(local.gateway_public_bandwidth, var.gateway_appliance_network_speed)
    memory               = var.gateway_memory
    ipv6_enabled         = true
  }
}

resource "ibm_network_gateway" "gateway_ha" {
  name  = var.gateway_name
  count = var.gateway_ha_enabled == true && var.deploy_gateway_appliance == true ? 1 : 0
  members {
    hostname             = var.hostname_gateway_1
    domain               = var.classic_domain
    datacenter           = var.classic_datacenter
    network_speed        = var.gateway_appliance_network_speed
    private_network_only = var.classic_gateway_private_only
    tcp_monitoring       = true
    process_key_name     = lookup(local.gateway_host_profiles, var.gateway_appliance_network_speed)
    os_key_name          = lookup(local.gateway_images, var.gateway_appliance_network_speed)
    package_key_name     = lookup(local.appliance_types, var.gateway_appliance_network_speed)
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = lookup(local.gateway_public_bandwidth, var.gateway_appliance_network_speed)
    memory               = var.gateway_memory
    ipv6_enabled         = true
  }
  members {
    hostname             = var.hostname_gateway_2
    domain               = var.classic_domain
    datacenter           = var.classic_datacenter
    network_speed        = var.gateway_appliance_network_speed
    private_network_only = var.classic_gateway_private_only
    tcp_monitoring       = true
    process_key_name     = lookup(local.gateway_host_profiles, var.gateway_appliance_network_speed)
    os_key_name          = lookup(local.gateway_images, var.gateway_appliance_network_speed)
    package_key_name     = lookup(local.appliance_types, var.gateway_appliance_network_speed)
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = lookup(local.gateway_public_bandwidth, var.gateway_appliance_network_speed)
    memory               = var.gateway_memory
    ipv6_enabled         = true
  }
}

## Creating the required IBM Cloud classic VLANs

resource "ibm_network_vlan" "management_vlan" {
  name       = "management-vlan"
  datacenter = var.classic_datacenter
  type       = "PRIVATE"
}

resource "ibm_network_vlan" "infra_vlan" {
  name       = "infra-vlan"
  datacenter = var.classic_datacenter
  type       = "PRIVATE"
}

resource "ibm_network_vlan" "data_vlan" {
  name       = "data-vlan"
  datacenter = var.classic_datacenter
  type       = "PRIVATE"
}

## Associating the VLANs to the single gateway (if existing)

resource "ibm_network_gateway_vlan_association" "single_gateway_management_vlan_association" {
  count           = var.gateway_ha_enabled == false && var.deploy_gateway_appliance == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_single[0].id
  network_vlan_id = ibm_network_vlan.management_vlan.id
  bypass          = "false"
}

resource "ibm_network_gateway_vlan_association" "single_gateway_infra_vlan_association" {
  count           = var.gateway_ha_enabled == false && var.deploy_gateway_appliance == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_single[0].id
  network_vlan_id = ibm_network_vlan.infra_vlan.id
  bypass          = "false"
}

resource "ibm_network_gateway_vlan_association" "single_gateway_data_vlan_association" {
  count           = var.gateway_ha_enabled == false && var.deploy_gateway_appliance == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_single[0].id
  network_vlan_id = ibm_network_vlan.data_vlan.id
  bypass          = "false"
}

## Associating the VLANs to the ha gateway (if existing)

resource "ibm_network_gateway_vlan_association" "ha_gateway_management_vlan_association" {
  count           = var.gateway_ha_enabled == true && var.deploy_gateway_appliance == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_ha[0].id
  network_vlan_id = ibm_network_vlan.management_vlan.id
}

resource "ibm_network_gateway_vlan_association" "ha_gateway_infra_vlan_association" {
  count           = var.gateway_ha_enabled == true && var.deploy_gateway_appliance == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_ha[0].id
  network_vlan_id = ibm_network_vlan.infra_vlan.id
  bypass          = "false"
}

resource "ibm_network_gateway_vlan_association" "ha_gateway_data_vlan_association" {
  count           = var.gateway_ha_enabled == true && var.deploy_gateway_appliance == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_ha[0].id
  network_vlan_id = ibm_network_vlan.data_vlan.id
  bypass          = "false"
}

## Import the pre-existing SSH key to use when provisioning the VSIs

data "ibm_compute_ssh_key" "classic_ssh_key_name" {
  label = var.classic_ssh_key_name
}

## Create the bastion security group in the classic environment

resource "ibm_security_group" "sg_bastion" {
  name = "${var.basename}-sg-bastion"
}

## Add a rule to the new security group to allow incoming SSH traffic and all outgoing network traffic for the bastion VSI

resource "ibm_security_group_rule" "allow_ingress_tcp_22_bastion" {
  security_group_id = ibm_security_group.sg_bastion.id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_all_egress_bastion" {
  security_group_id = ibm_security_group.sg_bastion.id
  direction         = "egress"
  remote_ip         = "0.0.0.0/0"
}

## Create the dns server security group in the classic environment

resource "ibm_security_group" "sg_dns_server" {
  name = "${var.basename}-sg-dns-server"
}

## Add a rule to the new security group to allow incoming SSH and DNS traffic and all outgoing network traffic for the DNS server VSI

resource "ibm_security_group_rule" "allow_ingress_tcp_22_dns_server" {
  security_group_id = ibm_security_group.sg_dns_server.id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_ingress_tcp_53_dns_server" {
  security_group_id = ibm_security_group.sg_dns_server.id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 53
  port_range_max    = 53
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_ingress_udp_53_dns_server" {
  security_group_id = ibm_security_group.sg_dns_server.id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 53
  port_range_max    = 53
  protocol          = "udp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_all_egress_dns_server" {
  security_group_id = ibm_security_group.sg_dns_server.id
  direction         = "egress"
  remote_ip         = "0.0.0.0/0"
}

## Create the proxy security group in the classic environment

resource "ibm_security_group" "sg_proxy" {
  name = "${var.basename}-sg-proxy"
}

## Add a rule to the new security group to allow incoming SSH traffic and all outgoing network traffic for the porxy VSI

resource "ibm_security_group_rule" "allow_ingress_tcp_22_proxy" {
  security_group_id = ibm_security_group.sg_proxy.id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_all_egress_proxy" {
  security_group_id = ibm_security_group.sg_proxy.id
  direction         = "egress"
  remote_ip         = "0.0.0.0/0"
}

## Creating the bastion VSI

resource "ibm_compute_vm_instance" "bastion" {
  hostname                   = "${var.basename}-bastion"
  domain                     = var.classic_domain
  os_reference_code          = var.bastion_os
  datacenter                 = var.classic_datacenter
  network_speed              = 1000
  hourly_billing             = true
  private_network_only       = var.bastion_private_only
  flavor_key_name            = var.instance_type_bastion
  local_disk                 = false
  ssh_key_ids                = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_bastion.id]
  private_vlan_id            = ibm_network_vlan.management_vlan.id
}

## Create the dns server VSI

resource "ibm_compute_vm_instance" "dns_server" {
  hostname                   = "${var.basename}-dns-server"
  domain                     = var.classic_domain
  os_reference_code          = var.dns_server_os
  datacenter                 = var.classic_datacenter
  network_speed              = 1000
  hourly_billing             = true
  private_network_only       = true
  flavor_key_name            = var.instance_type_dns_server
  local_disk                 = false
  ssh_key_ids                = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_dns_server.id]
  private_vlan_id            = ibm_network_vlan.infra_vlan.id
}

## Creating the proxy VSI

resource "ibm_compute_vm_instance" "proxy" {
  hostname                   = "${var.basename}-proxy"
  domain                     = var.classic_domain
  os_reference_code          = var.proxy_os
  datacenter                 = var.classic_datacenter
  network_speed              = 1000
  hourly_billing             = true
  private_network_only       = true
  flavor_key_name            = var.instance_type_proxy
  local_disk                 = false
  ssh_key_ids                = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_proxy.id]
  private_vlan_id            = ibm_network_vlan.infra_vlan.id
}

## Creating a VPC resource group to use when deploying the PowerVS

resource "ibm_resource_group" "resource_group" {
  name = var.pi_resource_group_name
}

## Creating a PowerVS workspace

resource "ibm_pi_workspace" "powervs_workspace_region_1" {
  provider             = ibm.ibm-pi-region-1
  pi_name              = "${var.basename}-${var.pi_workspace_name_region_1}"
  pi_datacenter        = var.pi_zone_region_1
  pi_resource_group_id = ibm_resource_group.resource_group.id
}

## Creating a subnet a subnet in the PowerVS workspace

resource "ibm_pi_network" "power_workspace_region_1_subnet_1" {
  provider             = ibm.ibm-pi-region-1
  pi_network_name      = "${var.basename}-${var.pi_workspace_name_region_1}-subnet-1"
  pi_cloud_instance_id = ibm_pi_workspace.powervs_workspace_region_1.id
  pi_network_type      = "vlan"
  pi_cidr              = var.pi_workspace_region_1_subnet_1
  pi_network_mtu       = 9000
}

## Creating first cloud connection between the region 1 PowerVS workspace and the classic environment

resource "ibm_pi_cloud_connection" "region_1_cloud_connection_1" {
  provider                                    = ibm.ibm-pi-region-1
  pi_cloud_instance_id                        = ibm_pi_workspace.powervs_workspace_region_1.id
  pi_cloud_connection_name                    = "${var.basename}-${var.pi_workspace_name_region_1}-cloud-connection-1"
  pi_cloud_connection_speed                   = var.pi_workspace_cloud_connection_speed
  pi_cloud_connection_gre_cidr                = var.pi_region_1_connection_1_gre_cidr
  pi_cloud_connection_gre_destination_address = (var.deploy_gateway_appliance == true ? "ibm_network_gateway.${lookup(local.classic_gateway_resource_name, var.gateway_ha_enabled)}.private_ipv4_address" : var.existing_classic_gateway_private_ip)
  pi_cloud_connection_networks                = [ibm_pi_network.power_workspace_region_1_subnet_1.network_id]
  pi_cloud_connection_classic_enabled         = true
}

## Creating second cloud connection between the region 1 PowerVS workspace and the tg3 transit gatewayin region 2

resource "ibm_pi_cloud_connection" "region_1_cloud_connection_2" {
  provider                            = ibm.ibm-pi-region-1
  pi_cloud_instance_id                = ibm_pi_workspace.powervs_workspace_region_1.id
  pi_cloud_connection_name            = "${var.basename}-${var.pi_workspace_name_region_1}-cloud-connection-2"
  pi_cloud_connection_speed           = var.pi_workspace_cloud_connection_speed
  pi_cloud_connection_networks        = [ibm_pi_network.power_workspace_region_1_subnet_1.network_id]
  pi_cloud_connection_transit_enabled = true
}

## Creating a CIS instance

resource "ibm_cis" "cis_instance" {
  name              = "${var.basename}-cis-instance"
  plan              = var.cis_plan
  resource_group_id = ibm_resource_group.resource_group.id
  location          = "global"
}

## Creating a COS instance

resource "ibm_resource_instance" "cos_instance" {
  name              = "${var.basename}-cos-instance-${var.classic_datacenter}"
  resource_group_id = ibm_resource_group.resource_group.id
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = "global"
}

## Creating a regional COS bucket in the same region as the classic VSIs and gateway

resource "ibm_cos_bucket" "cos_bucket_regional_smart" {
  bucket_name          = var.cos_bucket_name
  resource_instance_id = ibm_resource_instance.cos_instance.id
  region_location      = lookup(local.cos_region, var.classic_datacenter)
  storage_class        = var.cos_storage_class
}

# 2nd Regional Architecture Deployment
# ---------------------------------------------------------------------------------------------------------------------------

resource "ibm_network_gateway" "gateway_single_region_2" {
  count    = (var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == false && var.deploy_gateway_appliance_region_2 == true) ? 1 : 0
  provider = ibm.ibm_classic_region-2
  name     = var.gateway_name_region_2
  members {
    hostname             = var.hostname_gateway_1_region_2
    domain               = var.classic_domain_region_2
    datacenter           = var.classic_datacenter_region_2
    network_speed        = var.gateway_appliance_network_speed_region_2
    private_network_only = var.classic_gateway_private_only_region_2
    tcp_monitoring       = true
    process_key_name     = lookup(local.gateway_host_profiles, var.gateway_appliance_network_speed_region_2)
    os_key_name          = lookup(local.gateway_images, var.gateway_appliance_network_speed_region_2)
    package_key_name     = lookup(local.appliance_types, var.gateway_appliance_network_speed_region_2)
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = lookup(local.gateway_public_bandwidth, var.gateway_appliance_network_speed_region_2)
    memory               = var.gateway_memory_region_2
    ipv6_enabled         = true
  }
}

resource "ibm_network_gateway" "gateway_ha_region_2" {
  provider = ibm.ibm_classic_region-2
  name     = var.gateway_name_region_2
  count    = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == true && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  members {
    hostname             = var.hostname_gateway_1_region_2
    domain               = var.classic_domain_region_2
    datacenter           = var.classic_datacenter_region_2
    network_speed        = var.gateway_appliance_network_speed_region_2
    private_network_only = var.classic_gateway_private_only_region_2
    tcp_monitoring       = true
    process_key_name     = lookup(local.gateway_host_profiles, var.gateway_appliance_network_speed_region_2)
    os_key_name          = lookup(local.gateway_images, var.gateway_appliance_network_speed_region_2)
    package_key_name     = lookup(local.appliance_types, var.gateway_appliance_network_speed_region_2)
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = lookup(local.gateway_public_bandwidth, var.gateway_appliance_network_speed_region_2)
    memory               = var.gateway_memory_region_2
    ipv6_enabled         = true
  }
  members {
    hostname             = var.hostname_gateway_2_region_2
    domain               = var.classic_domain_region_2
    datacenter           = var.classic_datacenter_region_2
    network_speed        = var.gateway_appliance_network_speed_region_2
    private_network_only = var.classic_gateway_private_only_region_2
    tcp_monitoring       = true
    process_key_name     = lookup(local.gateway_host_profiles, var.gateway_appliance_network_speed_region_2)
    os_key_name          = lookup(local.gateway_images, var.gateway_appliance_network_speed_region_2)
    package_key_name     = lookup(local.appliance_types, var.gateway_appliance_network_speed_region_2)
    redundant_network    = true
    disk_key_names       = ["HARD_DRIVE_2_00_TB_SATA_2"]
    public_bandwidth     = lookup(local.gateway_public_bandwidth, var.gateway_appliance_network_speed_region_2)
    memory               = var.gateway_memory_region_2
    ipv6_enabled         = true
  }
}

## Creating the required IBM Cloud classic VLANs for 2nd region

resource "ibm_network_vlan" "management_vlan_region_2" {
  count      = var.deploy_region_2 == true ? 1 : 0
  provider   = ibm.ibm_classic_region-2
  name       = "management-vlan"
  datacenter = var.classic_datacenter_region_2
  type       = "PRIVATE"
}

resource "ibm_network_vlan" "infra_vlan_region_2" {
  count      = var.deploy_region_2 == true ? 1 : 0
  provider   = ibm.ibm_classic_region-2
  name       = "infra-vlan"
  datacenter = var.classic_datacenter_region_2
  type       = "PRIVATE"
}

resource "ibm_network_vlan" "data_vlan_region_2" {
  count      = var.deploy_region_2 == true ? 1 : 0
  provider   = ibm.ibm_classic_region-2
  name       = "data-vlan"
  datacenter = var.classic_datacenter_region_2
  type       = "PRIVATE"
}

## Associating the VLANs to the single gateway in the 2nd region (if existing)

resource "ibm_network_gateway_vlan_association" "single_gateway_management_vlan_association_region_2" {
  provider        = ibm.ibm_classic_region-2
  count           = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == false && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_single_region_2[0].id
  network_vlan_id = ibm_network_vlan.management_vlan_region_2[0].id
  bypass          = "false"
}

resource "ibm_network_gateway_vlan_association" "single_gateway_infra_vlan_association_region_2" {
  provider        = ibm.ibm_classic_region-2
  count           = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == false && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_single_region_2[0].id
  network_vlan_id = ibm_network_vlan.infra_vlan_region_2[0].id
  bypass          = "false"
}

resource "ibm_network_gateway_vlan_association" "single_gateway_data_vlan_association_region_2" {
  provider        = ibm.ibm_classic_region-2
  count           = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == false && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_single_region_2[0].id
  network_vlan_id = ibm_network_vlan.data_vlan_region_2[0].id
  bypass          = "false"
}

## Associating the VLANs to the ha gateway in the 2nd region (if existing)

resource "ibm_network_gateway_vlan_association" "ha_gateway_management_vlan_association_region_2" {
  provider        = ibm.ibm_classic_region-2
  count           = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == true && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_ha_region_2[0].id
  network_vlan_id = ibm_network_vlan.management_vlan_region_2[0].id
}

resource "ibm_network_gateway_vlan_association" "ha_gateway_infra_vlan_association_region_2" {
  provider        = ibm.ibm_classic_region-2
  count           = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == true && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_ha_region_2[0].id
  network_vlan_id = ibm_network_vlan.infra_vlan_region_2[0].id
  bypass          = "false"
}

resource "ibm_network_gateway_vlan_association" "ha_gateway_data_vlan_association_region_2" {
  provider        = ibm.ibm_classic_region-2
  count           = var.deploy_region_2 == true && var.gateway_ha_enabled_region_2 == true && var.deploy_gateway_appliance_region_2 == true ? 1 : 0
  gateway_id      = ibm_network_gateway.gateway_ha_region_2[0].id
  network_vlan_id = ibm_network_vlan.data_vlan_region_2[0].id
  bypass          = "false"
}

## Create the jump server security group in the classic environment for the 2nd region

resource "ibm_security_group" "sg_jump_server_region_2" {
  count = var.deploy_region_2 == true ? 1 : 0
  name  = "${var.basename}-sg-jump_server"
}

## Add a rule to the new security group to allow incoming SSH traffic and all outgoing network traffic for the jump server VSI in the 2nd region

resource "ibm_security_group_rule" "allow_ingress_tcp_22_jump_server_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_jump_server_region_2[0].id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_all_egress_jump_server_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_jump_server_region_2[0].id
  direction         = "egress"
  remote_ip         = "0.0.0.0/0"
}

## Create the dns server security group in the classic environment in the 2nd region

resource "ibm_security_group" "sg_dns_server_region_2" {
  count = var.deploy_region_2 == true ? 1 : 0
  name  = "${var.basename}-sg-dns-server"
}

## Add a rule to the new security group to allow incoming SSH and DNS traffic and all outgoing network traffic for the DNS server VSI in the 2nd region

resource "ibm_security_group_rule" "allow_ingress_tcp_22_dns_server_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_dns_server_region_2[0].id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_ingress_tcp_53_dns_server_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_dns_server_region_2[0].id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 53
  port_range_max    = 53
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_ingress_udp_53_dns_server_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_dns_server_region_2[0].id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 53
  port_range_max    = 53
  protocol          = "udp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_all_egress_dns_server_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_dns_server_region_2[0].id
  direction         = "egress"
  remote_ip         = "0.0.0.0/0"
}

## Create the proxy security group in the classic environment in the 2nd region

resource "ibm_security_group" "sg_proxy_region_2" {
  count = var.deploy_region_2 == true ? 1 : 0
  name  = "${var.basename}-sg-proxy"
}

## Add a rule to the new security group to allow incoming SSH traffic and all outgoing network traffic for the porxy VSI in the 2nd region

resource "ibm_security_group_rule" "allow_ingress_tcp_22_proxy_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_proxy_region_2[0].id
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "0.0.0.0/0"
}

resource "ibm_security_group_rule" "allow_all_egress_proxy_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  security_group_id = ibm_security_group.sg_proxy_region_2[0].id
  direction         = "egress"
  remote_ip         = "0.0.0.0/0"
}

## Creating the jump server VSI in the 2nd region

resource "ibm_compute_vm_instance" "jump_server_region_2" {
  count                      = var.deploy_region_2 == true ? 1 : 0
  provider                   = ibm.ibm_classic_region-2
  hostname                   = "${var.basename}-jump-server"
  domain                     = var.classic_domain_region_2
  os_reference_code          = var.jump_server_os_region_2
  datacenter                 = var.classic_datacenter_region_2
  network_speed              = 1000
  hourly_billing             = true
  private_network_only       = var.jump_server_private_only_region_2
  flavor_key_name            = var.instance_type_jump_server_region_2
  local_disk                 = false
  ssh_key_ids                = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_jump_server_region_2[0].id]
  private_vlan_id            = ibm_network_vlan.management_vlan_region_2[0].id
}

## Create the dns server VSI in the 2nd region

resource "ibm_compute_vm_instance" "dns_server_region_2" {
  count                      = var.deploy_region_2 == true ? 1 : 0
  provider                   = ibm.ibm_classic_region-2
  hostname                   = "${var.basename}-dns-server"
  domain                     = var.classic_domain_region_2
  os_reference_code          = var.dns_server_os_region_2
  datacenter                 = var.classic_datacenter_region_2
  network_speed              = 1000
  hourly_billing             = true
  private_network_only       = true
  flavor_key_name            = var.instance_type_dns_server_region_2
  local_disk                 = false
  ssh_key_ids                = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_dns_server_region_2[0].id]
  private_vlan_id            = ibm_network_vlan.infra_vlan_region_2[0].id
}

## Creating the proxy VSI in the 2nd region

resource "ibm_compute_vm_instance" "proxy_region_2" {
  count                      = var.deploy_region_2 == true ? 1 : 0
  provider                   = ibm.ibm_classic_region-2
  hostname                   = "${var.basename}-proxy"
  domain                     = var.classic_domain_region_2
  os_reference_code          = var.proxy_os_region_2
  datacenter                 = var.classic_datacenter_region_2
  network_speed              = 1000
  hourly_billing             = true
  private_network_only       = true
  flavor_key_name            = var.instance_type_proxy_region_2
  local_disk                 = false
  ssh_key_ids                = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_proxy_region_2[0].id]
  private_vlan_id            = ibm_network_vlan.infra_vlan_region_2[0].id
}

resource "ibm_pi_workspace" "powervs_workspace_region_2" {
  count                = var.deploy_region_2 == true ? 1 : 0
  provider             = ibm.ibm-pi-region-2
  pi_name              = "${var.basename}-${var.pi_workspace_name_region_2}"
  pi_datacenter        = var.pi_zone_region_2
  pi_resource_group_id = ibm_resource_group.resource_group.id
}

## Creating a subnet in the PowerVS workspace in the 2nd region

resource "ibm_pi_network" "power_workspace_region_2_subnet_1" {
  count                = var.deploy_region_2 == true ? 1 : 0
  provider             = ibm.ibm-pi-region-2
  pi_network_name      = "${var.basename}-${var.pi_workspace_name_region_2}-subnet-1"
  pi_cloud_instance_id = ibm_pi_workspace.powervs_workspace_region_2[0].id
  pi_network_type      = "vlan"
  pi_cidr              = var.pi_workspace_region_2_subnet_1
  pi_network_mtu       = 9000
}

## Creating first cloud connection between the region 2 PowerVS workspace and the transit gateway tgw 2 environment in the 2nd region

resource "ibm_pi_cloud_connection" "region_2_cloud_connection_1" {
  count                               = var.deploy_region_2 == true ? 1 : 0
  provider                            = ibm.ibm-pi-region-2
  pi_cloud_instance_id                = ibm_pi_workspace.powervs_workspace_region_2[0].id
  pi_cloud_connection_name            = "${var.basename}-${var.pi_workspace_name_region_2}-cloud-connection-1"
  pi_cloud_connection_speed           = var.pi_workspace_cloud_connection_speed_region_2
  pi_cloud_connection_networks        = [ibm_pi_network.power_workspace_region_2_subnet_1[0].network_id]
  pi_cloud_connection_transit_enabled = true
}

## Creating first cloud connection between the region 2 PowerVS workspace and the transit gateway tgw 3 environment in the 2nd region

resource "ibm_pi_cloud_connection" "region_2_cloud_connection_2" {
  count                               = var.deploy_region_2 == true ? 1 : 0
  provider                            = ibm.ibm-pi-region-2
  pi_cloud_instance_id                = ibm_pi_workspace.powervs_workspace_region_2[0].id
  pi_cloud_connection_name            = "${var.basename}-${var.pi_workspace_name_region_2}-cloud-connection-2"
  pi_cloud_connection_speed           = var.pi_workspace_cloud_connection_speed_region_2
  pi_cloud_connection_networks        = [ibm_pi_network.power_workspace_region_2_subnet_1[0].network_id]
  pi_cloud_connection_transit_enabled = true
}

## Creating a COS instance in the 2nd region

resource "ibm_resource_instance" "cos_instance_region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  name              = "${var.basename}-cos-instance-${var.classic_datacenter_region_2}"
  resource_group_id = ibm_resource_group.resource_group.id
  service           = "cloud-object-storage"
  plan              = var.cos_plan_region_2
  location          = "global"
}

## Creating a regional COS bucket in the same 2nd region as the classic VSIs and gateway

resource "ibm_cos_bucket" "cos_bucket_regional_smart_region_2" {
  count                = var.deploy_region_2 == true ? 1 : 0
  provider             = ibm.ibm_classic_region-2
  bucket_name          = var.cos_bucket_name_region_2
  resource_instance_id = ibm_resource_instance.cos_instance_region_2[0].id
  region_location      = lookup(local.cos_region, var.classic_datacenter_region_2)
  storage_class        = var.cos_storage_class_region_2
}

## Creating a VPC with Default ACL and Subnet attached in the 2nd region

resource "ibm_is_vpc" "vpc" {
  count                     = var.deploy_region_2 == true ? 1 : 0
  provider                  = ibm.ibm-pi-region-2
  name                      = "${var.basename}-${var.vpc_name_region_2}"
  resource_group            = ibm_resource_group.resource_group.id
  address_prefix_management = "manual"
}

resource "ibm_is_vpc_address_prefix" "vpc_address_prefix" {
  count    = var.deploy_region_2 == true ? 1 : 0
  provider = ibm.ibm-pi-region-2
  cidr     = var.vpc_address_prefix
  name     = "add-prefix"
  vpc      = ibm_is_vpc.vpc[0].id
  zone     = var.vpc_zone
}

resource "ibm_is_subnet" "subnet1" {
  count    = var.deploy_region_2 == true ? 1 : 0
  provider = ibm.ibm-pi-region-2
  depends_on = [
    ibm_is_vpc_address_prefix.vpc_address_prefix
  ]
  name            = "${var.basename}-${var.vpc_name_region_2}-subnet1"
  vpc             = ibm_is_vpc.vpc[0].id
  zone            = var.vpc_zone
  ipv4_cidr_block = var.vpc_cidr
}

## Creating the securirty group and rule/s to attach to the VPC

module "create_sgr_rule" {
  count   = var.deploy_region_2 == true ? 1 : 0
  source  = "terraform-ibm-modules/security-group/ibm"
  version = "~>2.6.2"
  providers = {
    ibm = ibm.ibm-pi-region-2
  }
  security_group_name = "${var.basename}-${var.vpc_name_region_2}-security-group"
  resource_group      = ibm_resource_group.resource_group.id
  security_group_rules = [{
    name      = "allow-all-outbound"
    direction = "outbound"
    remote    = "0.0.0.0/0"
  }]
  vpc_id = ibm_is_vpc.vpc[0].id
}

## Creating Virtual Endpoint Gateway in VPC targeted towards COS Instance

resource "ibm_is_virtual_endpoint_gateway" "vpc_region_2_vpe" {
  provider = ibm.ibm-pi-region-2
  count    = var.deploy_region_2 == true ? 1 : 0
  name     = "${var.basename}-${var.vpc_name_region_2}-endpoint-gateway"

  target {
    crn           = "crn:v1:bluemix:public:cloud-object-storage:global:::endpoint:s3.direct.${lookup(local.cos_region, var.classic_datacenter_region_2)}.cloud-object-storage.appdomain.cloud"
    resource_type = "provider_cloud_service"
  }
  vpc            = ibm_is_vpc.vpc[0].id
  resource_group = ibm_resource_group.resource_group.id
}


## Creating Transit Gateway 3 with a connection to Power from both Regions

resource "ibm_tg_gateway" "tg-region_2-3" {
  count          = var.deploy_region_2 == true ? 1 : 0
  name           = "${var.basename}-transit_gateway-3"
  location       = lookup(local.vpc_region, var.vpc_zone)
  global         = true
  resource_group = ibm_resource_group.resource_group.id
}

data "ibm_dl_gateway" "region_1_cloud_connection_2" {
  name = "${var.basename}-${var.pi_workspace_name_region_1}-cloud-connection-2"

  depends_on = [ibm_pi_cloud_connection.region_1_cloud_connection_2]
}

data "ibm_dl_gateway" "region_2_cloud_connection_2" {
  count = var.deploy_region_2 == true ? 1 : 0
  name  = "${var.basename}-${var.pi_workspace_name_region_2}-cloud-connection-2"

  depends_on = [ibm_pi_cloud_connection.region_2_cloud_connection_2]
}

resource "ibm_tg_connection" "tg3-connection-gre-powervs-from-region_1" {
  gateway      = ibm_tg_gateway.tg-region_2-3[0].id
  network_type = "directlink"
  name         = "${var.basename}-tgw3-gre-connection-power-region1"
  network_id   = data.ibm_dl_gateway.region_1_cloud_connection_2.crn
}

resource "ibm_tg_connection" "tg3_connection-powevs-from-region_2" {
  count        = var.deploy_region_2 == true ? 1 : 0
  gateway      = ibm_tg_gateway.tg-region_2-3[0].id
  network_type = "directlink"
  name         = "${var.basename}-tgw3-connection-power-region2"
  network_id   = data.ibm_dl_gateway.region_2_cloud_connection_2[0].crn
}

## Creating Transit Gateway 2 with a connection to Power, Classic and VPC

resource "ibm_tg_gateway" "tg-region_2-2" {
  count          = var.deploy_region_2 == true ? 1 : 0
  name           = "${var.basename}-transit_gateway-2"
  location       = lookup(local.vpc_region, var.vpc_zone)
  global         = true
  resource_group = ibm_resource_group.resource_group.id
}

resource "ibm_tg_connection" "tg2-connection-classic-region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  gateway           = ibm_tg_gateway.tg-region_2-2[0].id
  network_type      = "unbound_gre_tunnel"
  name              = "${var.basename}-tgw2-gre-classic-connection"
  base_network_type = "classic"
  local_tunnel_ip   = var.grec_tg2_local_tunnel_ip
  remote_gateway_ip = (var.deploy_gateway_appliance_region_2 == true ? "ibm_network_gateway.${lookup(local.classic_gateway_resource_name_region_2, var.gateway_ha_enabled_region_2)}.private_ipv4_address" : var.existing_classic_gateway_private_ip_region_2)
  local_gateway_ip  = var.grec_tg2_local_gateway_ip
  remote_tunnel_ip  = var.grec_tg2_remote_tunnel_ip
  zone              = var.vpc_zone
}

resource "ibm_tg_connection" "tg2_connection-vpc" {
  count        = var.deploy_region_2 == true ? 1 : 0
  gateway      = ibm_tg_gateway.tg-region_2-2[0].id
  network_type = "vpc"
  name         = "${var.basename}-tgw2-vpc-connection"
  network_id   = ibm_is_vpc.vpc[0].crn
}

data "ibm_dl_gateway" "region_2_cloud_connection_1" {
  name       = "${var.basename}-${var.pi_workspace_name_region_2}-cloud-connection-1"
  depends_on = [ibm_pi_cloud_connection.region_2_cloud_connection_1[0]]
}

resource "ibm_tg_connection" "tg2_connection-powevs-from-region_2" {
  count        = var.deploy_region_2 == true ? 1 : 0
  gateway      = ibm_tg_gateway.tg-region_2-2[0].id
  network_type = "directlink"
  name         = "${var.basename}-tgw2-connection-power-region2"
  network_id   = data.ibm_dl_gateway.region_2_cloud_connection_1.crn
}

## Creating Transit Gateway 1 with a connection to Classic

resource "ibm_tg_gateway" "tg-region_2-1" {
  count          = var.deploy_region_2 == true ? 1 : 0
  name           = "${var.basename}-transit_gateway-1"
  location       = lookup(local.vpc_region, var.vpc_zone)
  global         = false
  resource_group = ibm_resource_group.resource_group.id
}

resource "ibm_tg_connection" "tg1-connection-classic-region_2" {
  count             = var.deploy_region_2 == true ? 1 : 0
  gateway           = ibm_tg_gateway.tg-region_2-1[0].id
  network_type      = "redundant_gre"
  name              = "${var.basename}-tgw1-gre-classic-connection"
  base_network_type = "classic"
  tunnels {
    name              = "${var.basename}-tgw1-gre-classic-connection-tunnel-1"
    local_tunnel_ip   = var.grea_tg1_local_tunnel_ip_tunnel_1
    remote_gateway_ip = (var.deploy_gateway_appliance == true ? "ibm_network_gateway.${lookup(local.classic_gateway_resource_name_region_2, var.gateway_ha_enabled_region_2)}.private_ipv4_address" : var.existing_classic_gateway_private_ip_region_2)
    local_gateway_ip  = var.grea_tg1_local_gateway_ip_tunnel_1
    remote_tunnel_ip  = var.grea_tg1_remote_tunnel_ip_tunnel_1
    zone              = var.vpc_zone
  }
  tunnels {
    name              = "${var.basename}-tgw1-gre-classic-connection-tunnel-2"
    local_tunnel_ip   = var.grea_tg1_local_tunnel_ip_tunnel_2
    remote_gateway_ip = (var.deploy_gateway_appliance == true ? "ibm_network_gateway.${lookup(local.classic_gateway_resource_name_region_2, var.gateway_ha_enabled_region_2)}.private_ipv4_address" : var.existing_classic_gateway_private_ip_region_2)
    local_gateway_ip  = var.grea_tg1_local_gateway_ip_tunnel_2
    remote_tunnel_ip  = var.grea_tg1_remote_tunnel_ip_tunnel_2
    zone              = var.vpc_zone
  }
}
