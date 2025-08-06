## general naming variables

variable "basename" {
  type = string
  default = "terraform"
  description = "Prefix to use for naming the resources deployed by this automation"
}

## variables for the classic gateway

variable "classic_gateway_private_only" {
  type = bool
  default = false
  description = "If deploying the classic VRA gateway, whether to deploy it with private only connectivity"
}

variable "gateway_name" {
  type = string
  default = "gateway-appliance"
  description = "Name to use for the VRA classic gateway appliance (only used if deploying the VRA classic gateway appliance)"
}

variable "hostname_gateway_1" {
  type = string
  default = "gateway01"
  description = "Name to use for the first VRA classic gateway appliance instance (only used if deploying the VRA classic gateway appliance)"
}

variable "hostname_gateway_2" {
  type = string
  default = "gateway02"
  description = "Name to use for the second classic gateway appliance instance (only used if deploying the classic gateway appliance in HA mode)"
}

variable "classic_domain" {
  type = string
  default = "ibmcloud.private"
  description = "Domain name to use for the compute resources deployed in classic"
}

variable "classic_datacenter" {
  type = string
  description = "IBM Cloud classic availability zone name (in lower case) where to deploy the resources. A list of IBM Cloud classic availability zones can be found here: https://cloud.ibm.com/docs/overview?topic=overview-locations#data-centers"
  validation {
    condition = can(regex("^[a-z][a-z][a-z][0-9][0-9]$", var.classic_datacenter))
    error_message = "Only lower case characters or numbers are allowed"
  }

}

variable "deploy_gateway_appliance" {
  type = bool
  default = false
  description = "Whether or not to deploy the VRA classic gateway appliance"
}

variable "gateway_appliance_network_speed" {
  type = string
  default = 1000
  description = "Maximum network speed to use for the gateway appliance (1000 or 10000, 1000 = 1Gbps)"
  validation {
    condition = can(regex("^(1000|10000)$", var.gateway_appliance_network_speed))
    error_message = "Acceptable values: 1000, 10000."
    }
}
variable "gateway_ha_enabled" {
  type = bool
  default = "false"
  description = "If deploying the VRA classic gateway appliance, whether or not to deploy it in High Availability mode "
}

variable "gateway_memory"{
  type = string
  default = "32"
  description = "Amount of memory to use for the classic gateway appliance"
}

## variables for the classic VSIs provisioning

variable "bastion_os" {
  type = string
  default = "UBUNTU_24_64"
  description = "Operating system to use for the bastion VSI. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "dns_server_os" {
  type = string
  default = "UBUNTU_24_64"
  description = "Operating system to use for the bastion VSI. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "proxy_os" {
  type = string
  default = "UBUNTU_24_64"
  description = "Operating system to use for the proxy VSI. For a list of available OSes, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_bastion" {
  type = string
  default = "B1_2X4X25"
  description = "Instance type to use for the bastion VSI. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_dns_server" {
  type = string
  default = "B1_2X4X25"
  description = "Instance type to use for the DNS server VSI. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "instance_type_proxy" {
  type = string
  default = "B1_2X4X25"
  description = "Instance type to use for the proxy VSI. For a list of available instance profiles, use the 'https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json' ibmcloud API. See 'https://sldn.softlayer.com/article/authenticating-softlayer-api/' regarding how to access the API"
}

variable "bastion_private_only" {
  type = bool
  default = "true"
  description = "Whether or not the bastion VSI need to only have private connectivity"
}

variable "classic_ssh_key_name" {
  type = string
  description = "Name of the SSH key to use when provisioning the VSIs in order to be able to access them later. The SSH key must already exist in the account before deploying the resources"
}

## variables for authentication

variable "ibmcloud_api_key" {
  type = string
  description = "IBM Cloud API key used to provision the non-classic IBM Cloud resources"
}

variable "iaas_classic_username" {
  type = string
  description = "IBM Cloud classic user name used to provision the classic IBM Cloud resources. The classic username will usually be in the form of <ACCOUNT_ID>_<EMAIL_ADDRESS@email.com>"
}

variable "iaas_classic_api_key" {
  type = string
  description = "IBM Cloud classic API key used to provision the classic IBM Cloud resources"
}

## variable for services

variable "cis_plan" {
  type = string
  default = "standard-next"
  description = "CIS plan to use. The list of available plans can be found using the ibmcloud cli command 'ibmcloud catalog service internet-svcs'"
}

variable "cos_plan" {
    type = string
    default = "standard"
    description = "COS instance plan to use (standard or lite)"

      validation {
      condition = can(regex("^(standard|lite)$", var.cos_plan))
      error_message = "Acceptable values: standard, lite."
    }
}

variable "cos_bucket_name" {
    type = string
    default = "regional-cos-bucket"
    description = "Name for the regional COS bucket. Note that the COS bucket will be deployed in the same region as the classic gateway/virtual server instances if this is a multizone region or in the closest multi-zone region (eu-de for par01, ams03 and mil01, jap-osa for sng01 and che01, ca-tor for mon01, us-south for sjc03 and sjc04)"
}

variable "cos_storage_class" {
    type = string
    default = "smart"
    description = "COS storage class to use (standard, smart, cold or vault)"

    validation {
      condition = can(regex("^(standard|smart|cold|vault)$", var.cos_storage_class))
      error_message = "Acceptable values: standard, smart, cold, vault "
    }
}

variable "existing_classic_gateway_private_ip" {
    type = string
    description = "Provide the private IPv4 address of an existing IBM Cloud Classic Gateway. This is not needed if deploying a new VRA classic gateway through this automation"
    validation {
      condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.existing_classic_gateway_private_ip))
      error_message = "Must be a valid IPv4 address notation (e.g.: 10.0.0.1)."
    }
}

## variables for the powervs workspace

variable "pi_zone_region_1" {
    type = string
    description = "PowerVS availability zone to use, must be che01 or mon01 as the other Powervs regions are all PER enabled and do not support cloud connections"
    
    validation {
      condition = can(regex("^(che01|mon01)$", var.pi_zone_region_1))
      error_message = "must be che01 or mon01 as the other regions are all PER enabled and do not allow the creation of power cloud connections"
    }
}

variable "pi_resource_group_name" {
    type = string
    default = "terraform"
    description = "Name of the pre-existing resource group where the PowerVS worskspace will be created"
}

 variable "pi_workspace_name_region_1" {
     type = string
     default = "production-workspace"
     description = "Name of the PowerVS workspace to create"
 }

variable "pi_workspace_cloud_connection_speed" {
    type = string
    default = "1000"
    description = "Define the speed of the PowerVS Cloud connections to the classic environment (10, 50, 100, 200, 500, 1000, 2000, 5000 with 1000 = 1Gbps)."

    validation {
      condition = can(regex("^(10|50|100|200|500|1000|2000|5000)$", var.pi_workspace_cloud_connection_speed))
      error_message = "Valid values are: 50, 100, 200, 500, 1000, 2000, 5000 (10000 is not allowed as this prevents the configuration of GRE on the PowerVS Cloud Connection)"
    }
}

variable "pi_workspace_region_1_subnet_1" {
    type = string
    default = "192.168.0.0/24"
    description = "Subnet to use in the powerVS workspace in CIDR notation"
    
    validation {
      condition     = can(cidrnetmask(var.pi_workspace_region_1_subnet_1))
      error_message = "Must be a valid IPv4 subnet in CIDR notation (e.g.: 192.168.0.0/24)."
    }
}

variable "pi_region_1_connection_1_gre_cidr" {
    type = string
    description = "network CIDR to be used for configuring the GRE tunnel of the first PowerVS workspace cloud connection, refer to https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-example to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP"
    default = "172.16.0.0/29"

    validation {
      condition     = can(cidrnetmask(var.pi_region_1_connection_1_gre_cidr))
      error_message = "Must be a valid IPv4 address in CIDR notation (e.g.: 172.16.0.0/29)."
    }
}