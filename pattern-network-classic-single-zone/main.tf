locals {
  gateway_host_profiles = {
    10000 = "INTEL_XEON_5218_2_30"
    1000 = "INTEL_XEON_4210_2_20"
  }

  gateway_images = {
    10000 = "OS_VIRTUAL_ROUTER_APPLIANCE_22_X_UP_TO_20_GBPS_SUBSCRIPTION_EDITION_64_BIT"
    1000  = "OS_VIRTUAL_ROUTER_APPLIANCE_22_X_UP_TO_2_GBPS_SUBSCRIPTION_EDITION_64_BIT"
    }
  
  appliance_types = {
    10000 = "VIRTUAL_ROUTER_APPLIANCE_10_GPBS"
    1000 = "VIRTUAL_ROUTER_APPLIANCE_1_GPBS"
    }
 
  gateway_public_bandwidth = {
    10000 = "20000"
    1000 = "5000"
    }
  
  classic_gateway_resource_name= {
    true = "gateway_ha_gateway"
    false = "gateway_single"
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
}

resource "ibm_network_gateway" "gateway_single" {
  name = var.gateway_name
  count = "${var.gateway_ha_enabled == false && var.deploy_gateway_appliance == true ? 1 : 0}"
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
  name = var.gateway_name
  count = "${var.gateway_ha_enabled == true && var.deploy_gateway_appliance == true ? 1 : 0}"
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
  name            = "management-vlan"
  datacenter      = var.classic_datacenter
  type            = "PRIVATE"
}

resource "ibm_network_vlan" "infra_vlan" {
  name            = "infra-vlan"
  datacenter      = var.classic_datacenter
  type            = "PRIVATE"
}

resource "ibm_network_vlan" "data_vlan" {
  name            = "data-vlan"
  datacenter      = var.classic_datacenter
  type            = "PRIVATE"
}

## Associating the VLANs to the single gateway (if existing)

resource "ibm_network_gateway_vlan_association" "single_gateway_management_vlan_association" {
  count = "${var.gateway_ha_enabled == false  && var.deploy_gateway_appliance == true ? 1 : 0}"
  gateway_id = ibm_network_gateway.gateway_single[0].id
  network_vlan_id = ibm_network_vlan.management_vlan.id
  bypass = "false"
}

resource "ibm_network_gateway_vlan_association" "single_gateway_infra_vlan_association" {
  count = "${var.gateway_ha_enabled == false  && var.deploy_gateway_appliance == true ? 1 : 0}"
  gateway_id = ibm_network_gateway.gateway_single[0].id
  network_vlan_id = ibm_network_vlan.infra_vlan.id
  bypass = "false"
}

resource "ibm_network_gateway_vlan_association" "single_gateway_data_vlan_association" {
  count = "${var.gateway_ha_enabled == false  && var.deploy_gateway_appliance == true ? 1 : 0}"
  gateway_id = ibm_network_gateway.gateway_single[0].id
  network_vlan_id = ibm_network_vlan.data_vlan.id
  bypass = "false"
}

## Associating the VLANs to the ha gateway (if existing)

resource "ibm_network_gateway_vlan_association" "ha_gateway_management_vlan_association" {
  count = "${var.gateway_ha_enabled == true  && var.deploy_gateway_appliance == true ? 1 : 0}"
  gateway_id = ibm_network_gateway.gateway_ha[0].id
  network_vlan_id = ibm_network_vlan.management_vlan.id
}

resource "ibm_network_gateway_vlan_association" "ha_gateway_infra_vlan_association" {
  count = "${var.gateway_ha_enabled == true  && var.deploy_gateway_appliance == true ? 1 : 0}"
  gateway_id = ibm_network_gateway.gateway_ha[0].id
  network_vlan_id = ibm_network_vlan.infra_vlan.id
  bypass = "false"
}

resource "ibm_network_gateway_vlan_association" "ha_gateway_data_vlan_association" {
  count = "${var.gateway_ha_enabled == true  && var.deploy_gateway_appliance == true ? 1 : 0}"
  gateway_id = ibm_network_gateway.gateway_ha[0].id
  network_vlan_id = ibm_network_vlan.data_vlan.id
  bypass = "false"
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
  security_group_id     = ibm_security_group.sg_bastion.id
  direction = "ingress"
  ether_type = "IPv4"
  port_range_min = 22
  port_range_max = 22
  protocol = "tcp"
  remote_ip = "0.0.0.0/0"
  }

resource "ibm_security_group_rule" "allow_all_egress_bastion" {
  security_group_id     = ibm_security_group.sg_bastion.id
  direction = "egress"
  remote_ip = "0.0.0.0/0"
  }

## Create the dns server security group in the classic environment

resource "ibm_security_group" "sg_dns_server" {
  name = "${var.basename}-sg-dns-server"
  }

## Add a rule to the new security group to allow incoming SSH and DNS traffic and all outgoing network traffic for the DNS server VSI

resource "ibm_security_group_rule" "allow_ingress_tcp_22_dns_server" {
  security_group_id     = ibm_security_group.sg_dns_server.id
  direction = "ingress"
  ether_type = "IPv4"
  port_range_min = 22
  port_range_max = 22
  protocol = "tcp"
  remote_ip = "0.0.0.0/0"
  }

resource "ibm_security_group_rule" "allow_ingress_tcp_53_dns_server" {
  security_group_id     = ibm_security_group.sg_dns_server.id
  direction = "ingress"
  ether_type = "IPv4"
  port_range_min = 53
  port_range_max = 53
  protocol = "tcp"
  remote_ip = "0.0.0.0/0"
  }

resource "ibm_security_group_rule" "allow_ingress_udp_53_dns_server" {
  security_group_id     = ibm_security_group.sg_dns_server.id
  direction = "ingress"
  ether_type = "IPv4"
  port_range_min = 53
  port_range_max = 53
  protocol = "udp"
  remote_ip = "0.0.0.0/0"
  }

resource "ibm_security_group_rule" "allow_all_egress_dns_server" {
  security_group_id     = ibm_security_group.sg_dns_server.id
  direction = "egress"
  remote_ip = "0.0.0.0/0"
  }

## Create the proxy security group in the classic environment

resource "ibm_security_group" "sg_proxy" {
  name = "${var.basename}-sg-proxy"
  }

## Add a rule to the new security group to allow incoming SSH traffic and all outgoing network traffic for the porxy VSI

resource "ibm_security_group_rule" "allow_ingress_tcp_22_proxy" {
  security_group_id     = ibm_security_group.sg_proxy.id
  direction = "ingress"
  ether_type = "IPv4"
  port_range_min = 22
  port_range_max = 22
  protocol = "tcp"
  remote_ip = "0.0.0.0/0"
  }

resource "ibm_security_group_rule" "allow_all_egress_proxy" {
  security_group_id     = ibm_security_group.sg_proxy.id
  direction = "egress"
  remote_ip = "0.0.0.0/0"
  }

## Creating the bastion VSI

resource "ibm_compute_vm_instance" "bastion" {
  hostname             = "${var.basename}-bastion"
  domain               = var.classic_domain
  os_reference_code    = var.bastion_os
  datacenter           = var.classic_datacenter
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = var.bastion_private_only
  flavor_key_name      = var.instance_type_bastion
  local_disk           = false
  ssh_key_ids = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_bastion.id]
  private_vlan_id = ibm_network_vlan.management_vlan.id
  }

## Create the dns server VSI

resource "ibm_compute_vm_instance" "dns_server" {
  hostname             = "${var.basename}-dns-server"
  domain               = var.classic_domain
  os_reference_code    = var.dns_server_os
  datacenter           = var.classic_datacenter
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = true
  flavor_key_name      = var.instance_type_dns_server
  local_disk           = false
  ssh_key_ids = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_dns_server.id]
  private_vlan_id = ibm_network_vlan.infra_vlan.id
  }

## Creating the proxy VSI

resource "ibm_compute_vm_instance" "proxy" {
  hostname             = "${var.basename}-proxy"
  domain               = var.classic_domain
  os_reference_code    = var.proxy_os
  datacenter           = var.classic_datacenter
  network_speed        = 1000
  hourly_billing       = true
  private_network_only = true
  flavor_key_name      = var.instance_type_proxy
  local_disk           = false
  ssh_key_ids = [data.ibm_compute_ssh_key.classic_ssh_key_name.id]
  private_security_group_ids = [ibm_security_group.sg_proxy.id]
  private_vlan_id = ibm_network_vlan.infra_vlan.id
  }

## Creating a VPC resource group to use when deploying the PowerVS

resource "ibm_resource_group" "resourceGroup" {
  name     = var.pi_resource_group_name
}

## Creating a PowerVS workspace

resource "ibm_pi_workspace" "powervs_workspace_region_1" {
  provider = ibm.ibm-pi-region-1
  pi_name               = "${var.basename}-${var.pi_workspace_name_region_1}"
  pi_datacenter         = var.pi_zone_region_1
  pi_resource_group_id  = ibm_resource_group.resourceGroup.id
}

## Creating a subnet a subnet in the PowerVS workspace

resource "ibm_pi_network" "power_workspace_region_1_subnet_1" {
  provider = ibm.ibm-pi-region-1
  pi_network_name      = "${var.basename}-${var.pi_workspace_name_region_1}-subnet-1"
  pi_cloud_instance_id = ibm_pi_workspace.powervs_workspace_region_1.id
  pi_network_type      = "vlan"
  pi_cidr              = var.pi_workspace_region_1_subnet_1
  pi_network_mtu       = 9000
}

## Creating first cloud connection between the region 1 PowerVS workspace and the classic environment

resource "ibm_pi_cloud_connection" "region_1_cloud_connection_1" {
  provider = ibm.ibm-pi-region-1
  pi_cloud_instance_id        = ibm_pi_workspace.powervs_workspace_region_1.id
  pi_cloud_connection_name    = "${var.basename}-${var.pi_workspace_name_region_1}-cloud-connection-1"
  pi_cloud_connection_speed    = var.pi_workspace_cloud_connection_speed
  pi_cloud_connection_gre_cidr = var.pi_region_1_connection_1_gre_cidr
  pi_cloud_connection_gre_destination_address = (var.deploy_gateway_appliance == true ? "ibm_network_gateway.${lookup(local.classic_gateway_resource_name, var.gateway_ha_enabled)}.private_ipv4_address": var.existing_classic_gateway_private_ip)
  pi_cloud_connection_networks = [ibm_pi_network.power_workspace_region_1_subnet_1.network_id]
  pi_cloud_connection_classic_enabled = true
}

## Creating a CIS instance

resource "ibm_cis" "cis_instance" {
  name              = "${var.basename}-cis-instance"
  plan              = var.cis_plan
  resource_group_id = ibm_resource_group.resourceGroup.id
  location          = "global"
}

## Creating a COS instance

resource "ibm_resource_instance" "cos_instance" {
  name              = "${var.basename}-cos-instance"
  resource_group_id = ibm_resource_group.resourceGroup.id
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = "global"
}

## Creating a regional COS bucket in the same region as the classic VSIs and gateway

resource "ibm_cos_bucket" "cos_bucket_regional_smart" {
  bucket_name          = var.cos_bucket_name
  resource_instance_id = ibm_resource_instance.cos_instance.id
  region_location = lookup(local.cos_region, var.classic_datacenter)
  storage_class        = var.cos_storage_class
}