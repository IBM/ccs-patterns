# hybrid-cloud-networking-classic-single-zone-pattern-automation

This terraform code deploys the base networking infrastructure from the IBM Cloud Classic Edge gateway pattern described in detail here <https://cloud.ibm.com/docs/pattern-network-vrf-only?topic=pattern-network-vrf-only-introduction> into a single IBM Cloud region.

It is used to integrate on-premises access with classic infrastructure and Power Virtual Server workloads within the IBM Cloud without the use of a Transit Gateway.

This pattern allows on-premise traffic to flow into a set of firewalls prior to routing traffic to Cloud services in Classic and IBM Cloud’s PowerVS environments.

Though the default behaviour of the automation is to leverage a pre-existing classic gateway firewall, an IBM Cloud classic VRA gateway can optionally be deployed instead (either as single or HA appliances).

This pattern allows on-premise traffic to flow into a set of firewalls prior to routing traffic to IBM Cloud’s PowerVS and Virtual Private Cloud (VPC) environments. It is used to integrate on-premises access with classic infrastructure and Power Virtual Server workloads within the IBM Cloud.

Note that some additional configuration will be needed on the classic gateway appliance(s) and on the DNS server, bastion and proxy VSIs to make this pattern operational (see the Post deployment tasks section).

![Hybrid cloud networking classic single region](classic-VRF.jpg)

## Pre-requisites

- an [IBM Cloud account](https://cloud.ibm.com/registration)
- an [IBM Cloud classic API key](https://cloud.ibm.com/docs/account?topic=account-classic_keys&interface=ui) must exist and the account associated to it must have the correct IAM permissions
- an [IBM Cloud API key](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui) must exist and the account associated to it must have the correct IAM permissions
- An [SSH key](https://cloud.ibm.com/docs/ssh-keys?topic=ssh-keys-adding-an-ssh-key) must already exist in the IBM Cloud classic infrastructure account
- If not intending to use a new [Virtual Router Appliance (VRA)](https://cloud.ibm.com/docs/virtual-router-appliance?topic=virtual-router-appliance-getting-started-vra) gateway appliance, an [IBM Cloud gateway appliance](https://cloud.ibm.com/docs/gateway-appliance?topic=gateway-appliance-getting-started-ga) must be provisionned before running this automation (the private IP of the existing gateway appliance is a required parameter if not provisioning a VRA through this automation)
- [Virtual Routing and Forwarding (VRF)](https://cloud.ibm.com/docs/account?topic=account-vrf-service-endpoint&interface=ui) needs to be enabled in the classic environment

## Providers used

| Name | Version |
|------|---------|
| [ibm](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs) | > 1.66.0 |

## Resources

| Name | Type |
|------|------|
| [ibm_cis.cis_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cis) | resource |
| [ibm_compute_vm_instance.bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_cos_bucket.cos_bucket_regional_smart](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cos_bucket) | resource |
| [ibm_network_gateway.gateway_ha](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway) | resource |
| [ibm_network_gateway.gateway_single](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_data_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_infra_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_management_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_data_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_infra_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_management_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_vlan.data_vlan](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.infra_vlan](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.management_vlan](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_pi_cloud_connection.region_1_cloud_connection_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_pi_network.power_workspace_region_1_subnet_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_workspace.powervs_workspace_region_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_workspace) | resource |
| [ibm_resource_group.resourceGroup](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_group) | resource |
| [ibm_resource_instance.cos_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_security_group.sg_bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group_rule.allow_all_egress_bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_53_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_udp_53_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_compute_ssh_key.classic_ssh_key_name](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/compute_ssh_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| basename | Prefix to use for naming the resources deployed by this automation | `string` | `"terraform"` | no |
| bastion_os | Operating system to use for the bastion VSI. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| bastion_private_only | Whether or not the bastion VSI need to only have private connectivity | `bool` | `"true"` | no |
| cis_plan | CIS plan to use. The list of available plans can be found using the ibmcloud cli command 'ibmcloud catalog service internet-svcs' | `string` | `"standard-next"` | no |
| classic_datacenter | IBM Cloud classic availability zone name (in lower case) where to deploy the resources. A list of IBM Cloud classic availability zones can be found here: <https://cloud.ibm.com/docs/overview?topic=overview-locations#data-centers> | `string` | n/a | yes |
| classic_domain | Domain name to use for the compute resources deployed in classic | `string` | `"ibmcloud.private"` | no |
| classic_gateway_private_only | If deploying the classic VRA gateway, whether to deploy it with private only connectivity | `bool` | `false` | no |
| classic_ssh_key_name | Name of the SSH key to use when provisioning the VSIs in order to be able to access them later. The SSH key must already exist in the account before deploying the resources | `string` | n/a | yes |
| cos_bucket_name | Name for the regional COS bucket. Note that the COS bucket will be deployed in the same region as the classic gateway/virtual server instances if this is a multizone region or in the closest multi-zone region (eu-de for par01, ams03 and mil01, jap-osa for sng01 and che01, ca-tor for mon01, us-south for sjc03 and sjc04) | `string` | `"regional-cos-bucket"` | no |
| cos_plan | COS instance plan to use (standard or lite) | `string` | `"standard"` | no |
| cos_storage_class | COS storage class to use (standard, smart, cold or vault) | `string` | `"smart"` | no |
| deploy_gateway_appliance | Whether or not to deploy the VRA classic gateway appliance | `bool` | `false` | no |
| dns_server_os | Operating system to use for the DNS server VSI. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| existing_classic_gateway_private_ip | Provide the private IPv4 address of an existing IBM Cloud Classic Gateway. This is not needed if deploying a new VRA classic gateway through this automation | `string` | n/a | yes |
| gateway_appliance_network_speed | Maximum network speed to use for the gateway appliance (1000 or 10000, 1000 = 1Gbps) | `string` | `1000` | no |
| gateway_ha_enabled | If deploying the VRA classic gateway appliance, whether or not to deploy it in High Availability mode | `bool` | `"false"` | no |
| gateway_memory | Amount of memory to use for the classic gateway appliance | `string` | `"32"` | no |
| gateway_name | Name to use for the VRA classic gateway appliance (only used if deploying the VRA classic gateway appliance) | `string` | `"gateway-appliance"` | no |
| hostname_gateway_1 | Name to use for the first VRA classic gateway appliance instance (only used if deploying the VRA classic gateway appliance) | `string` | `"gateway01"` | no |
| hostname_gateway_2 | Name to use for the second classic gateway appliance instance (only used if deploying the classic gateway appliance in HA mode) | `string` | `"gateway02"` | no |
| iaas_classic_api_key | IBM Cloud classic API key used to provision the classic IBM Cloud resources | `string` | n/a | yes |
| iaas_classic_username | IBM Cloud classic user name used to provision the classic IBM Cloud resources | `string` | n/a | yes |
| ibmcloud_api_key | IBM Cloud API key used to provision the non-classic IBM Cloud resources | `string` | n/a | yes |
| instance_type_bastion | Instance type to use for the bastion VSI. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| instance_type_dns_server | Instance type to use for the DNS server VSI. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| instance_type_proxy | Instance type to use for the proxy VSI. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| pi_region_1_connection_1_gre_cidr | network CIDR to be used for configuring the GRE tunnel of the first PowerVS workspace cloud connection, refer to <https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-example> to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP, refer to <https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-example> to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP | `string` | `"172.16.0.0/29"` | no |
| pi_resource_group_name | Name of the pre-existing resource group where the PowerVS worskspace will be created | `string` | `"terraform"` | no |
| pi_workspace_cloud_connection_speed | Define the speed of the PowerVS Cloud connections to the classic environment (10, 50, 100, 200, 500, 1000, 2000, 5000 with 1000 = 1Gbps). | `string` | `"1000"` | no |
| pi_workspace_name_region_1 | Name of the PowerVS workspace to create | `string` | `"production-workspace"` | no |
| pi_workspace_region_1_subnet_1 | Subnet to use in the powerVS workspace in CIDR notation | `string` | `"192.168.0.0/24"` | no |
| pi_zone_region_1 | PowerVS availability zone to use, must be che01, mon01 or lon04 as the other Powervs regions are all PER enabled and do not support cloud connections | `string` | n/a | yes |
| proxy_os | Operating system to use for the proxy VSI. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |

## Post deployment tasks

- if there was a pre-existing classic gateway appliance, associate the VLANs created by the automation to it
- finish the configuration of the classic gateway appliance (VLANs configuration, firewall rules configuration)
- add a second [cloud connection](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#create-cloud-connections) in the PowerVS workspace created by the automation for redundancy and configure GRE on it
- configure two GRE tunnel interfaces on the classic gateway appliance(s) to terminate the PowerVS to classic GRE tunnels and configure BGP over these tunnels (labbeled as GREc on the diagram)
- install and configure the DNS server, proxy and bastion softwares on the VSIs created by the automation
- order two [direct link](/docs/dl?topic=dl-get-started-with-ibm-cloud-dl) from on-prem to the environment
- once the direct links are operationl, configure two GRE tunnels between the classic gateway appliance and the on premises customer router (labelled as GREa on the diagram) and configure BGP over these GRE tunnels.
- adjust the [security groups rules](https://cloud.ibm.com/docs/security-groups?topic=security-groups-creating-security-groups) of the VSIs created by the automation as needed.
- install and configure the DNS server, proxy and bastion softwares on the VSIs created by the automation
