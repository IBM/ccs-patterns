## general naming variables

variable "basename" {
  type        = string
  default     = "terraform"
  description = "Prefix to use for naming the resources deployed by this automation"
}

## variables for the classic gateway

variable "classic_gateway_private_only" {
  type        = bool
  default     = false
  description = "If deploying the classic VRA gateway, whether to deploy it with private only connectivity"
}

variable "gateway_name" {
  type        = string
  default     = "gateway-appliance"
  description = "Name to use for the VRA classic gateway appliance (only used if deploying the VRA classic gateway appliance)"
}

variable "hostname_gateway_1" {
  type        = string
  default     = "gateway01"
  description = "Name to use for the first VRA classic gateway appliance instance (only used if deploying the VRA classic gateway appliance)"
}

variable "hostname_gateway_2" {
  type        = string
  default     = "gateway02"
  description = "Name to use for the second classic gateway appliance instance (only used if deploying the classic gateway appliance in HA mode)"
}

variable "classic_domain" {
  type        = string
  default     = "ibmcloud.private"
  description = "Domain name to use for the compute resources deployed in classic"
}

variable "classic_datacenter" {
  type        = string
  description = "IBM Cloud classic availability zone name (in lower case) where to deploy the resources. A list of IBM Cloud classic availability zones can be found here: https://cloud.ibm.com/docs/overview?topic=overview-locations#data-centers"
  validation {
    condition     = can(regex("^[a-z][a-z][a-z][0-9][0-9]$", var.classic_datacenter))
    error_message = "Only lower case characters or numbers are allowed"
  }

}

variable "deploy_gateway_appliance" {
  type        = bool
  default     = false
  description = "Whether or not to deploy the VRA classic gateway appliance"
}

variable "gateway_appliance_network_speed" {
  type        = string
  default     = 1000
  description = "Maximum network speed to use for the gateway appliance (1000 or 10000, 1000 = 1Gbps)"
  validation {
    condition     = can(regex("^(1000|10000)$", var.gateway_appliance_network_speed))
    error_message = "Acceptable values: 1000, 10000."
  }
}
variable "gateway_ha_enabled" {
  type        = bool
  default     = "false"
  description = "If deploying the VRA classic gateway appliance, whether or not to deploy it in High Availability mode "
}

variable "gateway_memory" {
  type        = string
  default     = "32"
  description = "Amount of memory to use for the classic gateway appliance"
}

## variables for the classic VSIs provisioning

variable "bastion_os" {
  type        = string
  default     = "UBUNTU_24_64"
  description = "Operating system to use for the bastion VSI. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "dns_server_os" {
  type        = string
  default     = "UBUNTU_24_64"
  description = "Operating system to use for the bastion VSI. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "proxy_os" {
  type        = string
  default     = "UBUNTU_24_64"
  description = "Operating system to use for the proxy VSI. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_bastion" {
  type        = string
  default     = "B1_2X4X25"
  description = "Instance type to use for the bastion VSI. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_dns_server" {
  type        = string
  default     = "B1_2X4X25"
  description = "Instance type to use for the DNS server VSI. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_proxy" {
  type        = string
  default     = "B1_2X4X25"
  description = "Instance type to use for the proxy VSI. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "bastion_private_only" {
  type        = bool
  default     = "true"
  description = "Whether or not the bastion VSI need to only have private connectivity"
}

variable "classic_ssh_key_name" {
  type        = string
  description = "Name of the SSH key to use when provisioning the VSIs in order to be able to access them later. The SSH key must already exist in the account before deploying the resources"
}

## variables for authentication

variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API key used to provision the non-classic IBM Cloud resources"
}

variable "iaas_classic_username" {
  type        = string
  description = "IBM Cloud classic user name used to provision the classic IBM Cloud resources. The classic username will usually be in the form of <ACCOUNT_ID>_<EMAIL_ADDRESS@email.com>"
}

variable "iaas_classic_api_key" {
  type        = string
  description = "IBM Cloud classic API key used to provision the classic IBM Cloud resources"
}

## variable for services

variable "cis_plan" {
  type        = string
  default     = "standard-next"
  description = "CIS plan to use. The list of available plans can be found using the ibmcloud cli command 'ibmcloud catalog service internet-svcs'"
}

variable "cos_plan" {
  type        = string
  default     = "standard"
  description = "COS instance plan to use (standard or lite)"

  validation {
    condition     = can(regex("^(standard|lite)$", var.cos_plan))
    error_message = "Acceptable values: standard, lite."
  }
}

variable "cos_bucket_name" {
  type        = string
  default     = "regional-cos-bucket"
  description = "Name for the regional COS bucket. Note that the COS bucket will be deployed in the same region as the classic gateway/virtual server instances if this is a multizone region or in the closest multi-zone region (eu-de for par01, ams03 and mil01, jap-osa for sng01 and che01, ca-tor for mon01, us-south for sjc03 and sjc04)"
}

variable "cos_storage_class" {
  type        = string
  default     = "smart"
  description = "COS storage class to use (standard, smart, cold or vault)"

  validation {
    condition     = can(regex("^(standard|smart|cold|vault)$", var.cos_storage_class))
    error_message = "Acceptable values: standard, smart, cold, vault "
  }
}

variable "existing_classic_gateway_private_ip" {
  type        = string
  description = "Provide the private IPv4 address of an existing IBM Cloud Classic Gateway. This is not needed if deploying a new VRA classic gateway through this automation"
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.existing_classic_gateway_private_ip))
    error_message = "Must be a valid IPv4 address notation (e.g.: 10.0.0.1)."
  }
}

## variables for the powervs workspace

variable "pi_zone_region_1" {
  type        = string
  description = "PowerVS availability zone to use, must be che01 or mon01 as the other Powervs regions are all PER enabled and do not support cloud connections"

  validation {
    condition     = can(regex("^(che01|mon01)$", var.pi_zone_region_1))
    error_message = "must be che01 or mon01 as the other regions are all PER enabled and do not allow the creation of power cloud connections"
  }
}

variable "pi_resource_group_name" {
  type        = string
  default     = "terraform"
  description = "Name of the pre-existing resource group where the PowerVS worskspace will be created"
}

variable "pi_workspace_name_region_1" {
  type        = string
  default     = "production-workspace"
  description = "Name of the PowerVS workspace to create"
}

variable "pi_workspace_cloud_connection_speed" {
  type        = string
  default     = "1000"
  description = "Define the speed of the PowerVS Cloud connections to the classic environment (10, 50, 100, 200, 500, 1000, 2000, 5000 with 1000 = 1Gbps)."

  validation {
    condition     = can(regex("^(10|50|100|200|500|1000|2000|5000)$", var.pi_workspace_cloud_connection_speed))
    error_message = "Valid values are: 50, 100, 200, 500, 1000, 2000, 5000 (10000 is not allowed as this prevents the configuration of GRE on the PowerVS Cloud Connection)"
  }
}

variable "pi_workspace_region_1_subnet_1" {
  type        = string
  default     = "192.168.0.0/24"
  description = "Subnet to use in the powerVS workspace in CIDR notation"

  validation {
    condition     = can(cidrnetmask(var.pi_workspace_region_1_subnet_1))
    error_message = "Must be a valid IPv4 subnet in CIDR notation (e.g.: 192.168.0.0/24)."
  }
}

variable "pi_region_1_connection_1_gre_cidr" {
  type        = string
  description = "network CIDR to be used for configuring the GRE tunnel of the first PowerVS workspace cloud connection, refer to https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-example to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP"
  default     = "172.16.0.0/29"

  validation {
    condition     = can(cidrnetmask(var.pi_region_1_connection_1_gre_cidr))
    error_message = "Must be a valid IPv4 address in CIDR notation (e.g.: 172.16.0.0/29)."
  }
}

## 2nd Regional Architecture Deployment
## ---------------------------------------------------------------------------------------------------------------------------

variable "deploy_region_2" {
  type        = bool
  default = false
  description = "A flag whether or not to deploy the 2nd regional infrastructure."
}

## Variables for the Classic Gateway in the 2nd region

variable "gateway_name_region_2" {
  type        = string
  default     = "gateway-appliance"
  description = "Name to use for the VRA classic gateway appliance in the 2nd region. (only used if deploying the VRA classic gateway appliance)"
}

variable "hostname_gateway_1_region_2" {
  type        = string
  default     = "gateway01"
  description = "Name to use for the first VRA classic gateway appliance instance in the 2nd region. (only used if deploying the VRA classic gateway appliance)"
}

variable "hostname_gateway_2_region_2" {
  type        = string
  default     = "gateway02"
  description = "Name to use for the second classic gateway appliance instance in the 2nd region. (only used if deploying the classic gateway appliance in HA mode)"
}

variable "classic_domain_region_2" {
  type        = string
  default     = "ibmcloud.private"
  description = "Domain name to use for the compute resources deployed in classic in the 2nd region."
}

variable "classic_datacenter_region_2" {
  type        = string
  description = "IBM Cloud classic availability zone name (in lower case) where to deploy the resources in the 2nd region. A list of IBM Cloud classic availability zones can be found here: https://cloud.ibm.com/docs/overview?topic=overview-locations#data-centers"
  validation {
    condition     = can(regex("^[a-z][a-z][a-z][0-9][0-9]$", var.classic_datacenter_region_2))
    error_message = "Only lower case characters or numbers are allowed"
  }
}

variable "classic_gateway_private_only_region_2" {
  type        = bool
  default     = false
  description = "If deploying the classic VRA gateway in the 2nd region, whether to deploy it with private only connectivity."
}

variable "gateway_ha_enabled_region_2" {
  type        = bool
  default     = "false"
  description = "If deploying the VRA classic gateway appliance in the 2nd region, whether or not to deploy it in High Availability mode "
}

variable "deploy_gateway_appliance_region_2" {
  type        = bool
  default     = false
  description = "Whether or not to deploy the VRA classic gateway appliance in the 2nd region."
}

variable "gateway_appliance_network_speed_region_2" {
  type        = string
  default     = 1000
  description = "Maximum network speed to use for the gateway appliance in the 2nd region. (1000 or 10000, 1000 = 1Gbps)"
  validation {
    condition     = can(regex("^(1000|10000)$", var.gateway_appliance_network_speed_region_2))
    error_message = "Acceptable values: 1000, 10000."
  }
}

variable "gateway_memory_region_2" {
  type        = string
  default     = "32"
  description = "Amount of memory to use for the classic gateway appliance in the 2nd region."
}

## Variables for the Classic VSIs provisioning in the 2nd region

variable "jump_server_os_region_2" {
  type        = string
  default     = "UBUNTU_24_64"
  description = "Operating system to use for the jump server VSI in the 2nd region. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "jump_server_private_only_region_2" {
  type        = bool
  default     = "true"
  description = "Whether or not the jump server VSI need to only have private connectivity in the 2nd region."
}

variable "instance_type_jump_server_region_2" {
  type        = string
  default     = "B1_2X4X25"
  description = "Instance type to use for the jump server VSI in the 2nd region. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "dns_server_os_region_2" {
  type        = string
  default     = "UBUNTU_24_64"
  description = "Operating system to use for the bastion VSI in the 2nd region.. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_dns_server_region_2" {
  type        = string
  default     = "B1_2X4X25"
  description = "Instance type to use for the DNS server VSI in the 2nd region. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "proxy_os_region_2" {
  type        = string
  default     = "UBUNTU_24_64"
  description = "Operating system to use for the proxy VSI in the 2nd region. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_proxy_region_2" {
  type        = string
  default     = "B1_2X4X25"
  description = "Instance type to use for the proxy VSI in the 2nd region. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

## Variables for the PowerVS workspace in the 2nd region


variable "pi_zone_region_2" {
  type        = string
  description = "PowerVS availability zone to use in the 2nd region, must be che01, mon01 or lon04 as the other Powervs regions are all PER enabled and do not support cloud connections"

  validation {
    condition     = can(regex("^(che01|mon01)$", var.pi_zone_region_2))
    error_message = "must be che01 or mon01 as the other regions are all PER enabled and do not allow the creation of power cloud connections"
  }
}

variable "pi_workspace_name_region_2" {
  type        = string
  default     = "disaster-recovery-workspace"
  description = "Name of the PowerVS workspace to create in the 2nd region."
}

variable "pi_workspace_region_2_subnet_1" {
  type        = string
  default     = "192.168.0.0/24"
  description = "Subnet to use in the powerVS workspace in CIDR notation in the 2nd region."

  validation {
    condition     = can(cidrnetmask(var.pi_workspace_region_2_subnet_1))
    error_message = "Must be a valid IPv4 subnet in CIDR notation (e.g.: 192.168.0.0/24)."
  }
}

variable "pi_workspace_cloud_connection_speed_region_2" {
  type        = string
  default     = "1000"
  description = "Define the speed of the PowerVS Cloud connections to the classic environment in the 2nd region. (10, 50, 100, 200, 500, 1000, 2000, 5000 with 1000 = 1Gbps)"

  validation {
    condition     = can(regex("^(10|50|100|200|500|1000|2000|5000)$", var.pi_workspace_cloud_connection_speed_region_2))
    error_message = "Valid values are: 50, 100, 200, 500, 1000, 2000, 5000 (10000 is not allowed as this prevents the configuration of GRE on the PowerVS Cloud Connection)"
  }
}

variable "pi_region_2_connection_1_gre_cidr" {
  type        = string
  description = "Network CIDR to be used for configuring the GRE tunnel of the first PowerVS workspace cloud connection in the 2nd region, refer to https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-example to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP"
  default     = "172.16.0.8/29"

  validation {
    condition     = can(cidrnetmask(var.pi_region_2_connection_1_gre_cidr))
    error_message = "Must be a valid IPv4 address in CIDR notation (e.g.: 172.16.0.0/29)."
  }
}

## Variables for Services in the 2nd region

variable "cos_plan_region_2" {
  type        = string
  default     = "standard"
  description = "COS instance plan to use in the 2nd region. (standard or lite)"

  validation {
    condition     = can(regex("^(standard|lite)$", var.cos_plan_region_2))
    error_message = "Acceptable values: standard, lite."
  }
}

variable "cos_bucket_name_region_2" {
  type        = string
  default     = "regional-cos-bucket-region-2"
  description = "Name for the regional COS bucket in the 2nd region. Note that the COS bucket will be deployed in the same region as the classic gateway/virtual server instances if this is a multizone region or in the closest multi-zone region (eu-de for par01, ams03 and mil01, jap-osa for sng01 and che01, ca-tor for mon01, us-south for sjc03 and sjc04)"
}

variable "cos_storage_class_region_2" {
  type        = string
  default     = "smart"
  description = "COS storage class to use in the 2nd region. (standard, smart, cold or vault)"

  validation {
    condition     = can(regex("^(standard|smart|cold|vault)$", var.cos_storage_class_region_2))
    error_message = "Acceptable values: standard, smart, cold, vault "
  }
}

variable "existing_classic_gateway_private_ip_region_2" {
  type        = string
  description = "Provide the private IPv4 address of an existing IBM Cloud Classic Gateway in the 2nd region. This is not needed if deploying a new VRA classic gateway through this automation."

  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.existing_classic_gateway_private_ip_region_2))
    error_message = "Must be a valid IPv4 address notation (e.g.: 10.0.0.1)."
  }
}

## Variables for VPC

variable "vpc_zone" {
  type = string
  default = "ca-mon-1"

  description = "The zone in which the VPC will be deployed (e.g., ca-tor-1, eu-gb-1, us-south-1)."
  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.vpc_zone))
    error_message = "Invalid VPC zone format. Use values like 'ca-mon-1', 'eu-gb-1' or 'us-south-1'."
  }
}

variable "vpc_name_region_2" {
  type        = string
  default     = "disaster-recovery-vpc"
  description = "Name of the VPC to create."
}

variable "total_ipv4_address_count" {
  description = "The total number of IPv4 addresses."
  type        = string
  default     = "256"

  validation {
    condition     = can(regex("^\\d+$", var.total_ipv4_address_count))
    error_message = "The string must contain only numeric characters (0-9)."
  }
}

variable "vpc_cidr" {
  description = "The subnet IP range for the VPC, needs to belong to the defined address prefix."
  type        = string
  default     = "192.168.10.0/24"
}

variable "vpc_address_prefix" {
  description = "The address prefix for the  VPC zone."
  type        = string
  default     = "192.168.10.0/18"


  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])/(3[0-2]|[1-2]?[0-9])$", var.vpc_address_prefix))
    error_message = "Ensure you are using the correct CIDR syntax e.g. 192.168.0.0/24"
  }
}

# Transit Gateway 2 GREc Connection Variables for 2nd Region

variable "grec_tg2_local_tunnel_ip" {
  description = "Local GRE Tunnel IP for grec on transit gateway 2"
  type        = string
  default     = "172.16.3.5"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grec_tg2_local_tunnel_ip))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grec_tg2_remote_tunnel_ip" {
  description = "Remote GRE Tunnel IP for grec on transit gateway 2"
  type        = string
  default     = "172.16.3.6"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grec_tg2_remote_tunnel_ip))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grec_tg2_local_gateway_ip" {
  description = "Private IP address of the existing Classic Gateway in region 2"
  type        = string
  default     = "172.16.3.1"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grec_tg2_local_gateway_ip))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

# Transit Gateway 1 GREa Connection Variables

variable "grea_tg1_local_tunnel_ip_tunnel_1" {
  description = "Local GRE Tunnel IP for tunnel 1 of grea on transit gateway 1"
  type        = string
  default     = "172.16.4.5"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grea_tg1_local_tunnel_ip_tunnel_1))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grea_tg1_local_tunnel_ip_tunnel_2" {
  description = "Local GRE Tunnel IP for tunnel 2 of grea on transit gateway 1"
  type        = string
  default     = "172.16.5.5"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grea_tg1_local_tunnel_ip_tunnel_2))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grea_tg1_remote_tunnel_ip_tunnel_1" {
  description = "Remote GRE Tunnel IP for tunnel 1 of grea on transit gateway 1"
  type        = string
  default     = "172.16.4.6"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grea_tg1_remote_tunnel_ip_tunnel_1))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grea_tg1_remote_tunnel_ip_tunnel_2" {
  description = "Remote GRE Tunnel IP for tunnel 2 grea on transit gateway 1"
  type        = string
  default     = "172.16.5.6"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grea_tg1_remote_tunnel_ip_tunnel_2))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grea_tg1_local_gateway_ip_tunnel_1" {
  description = "Private IP address of the existing Classic Gateway in region 2"
  type        = string
  default     = "172.16.4.1"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grea_tg1_local_gateway_ip_tunnel_1))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "grea_tg1_local_gateway_ip_tunnel_2" {
  description = "Private IP address of the existing Classic Gateway in region 2"
  type        = string
  default     = "172.16.5.1"

  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$", var.grea_tg1_local_gateway_ip_tunnel_2))
    error_message = "Ensure you are using a valid IPv4 address (e.g., 192.168.1.1)."
  }
}