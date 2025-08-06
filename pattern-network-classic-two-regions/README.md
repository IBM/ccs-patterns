# Hybrid cloud networking for classic infrastructure across two regions (disaster recovery scenario)

This terraform code deploys the base networking infrastructure from the IBM Cloud Classic Edge gateway pattern described in detail here **<https://cloud.ibm.com/docs/pattern-network-vrf-only?topic=pattern-network-vrf-only-introduction>** into two IBM Cloud regions to provide the base networking infrastructure for a disaster recovery scenario.

It is used to integrate on-premises access with classic infrastructure and Power Virtual Server workloads within two IBM Cloud regions, leveraging direct PowerConnect and GRE connections in the primary region and VPC Transit Gateways in the secondary region.

This pattern allows on-premise traffic to flow into a set of firewalls prior to routing traffic to Cloud services in Classic and IBM Cloud’s PowerVS environments.

Though the default behaviour of the automation is to leverage a pre-existing classic gateway firewall, an IBM Cloud classic VRA gateway can optionally be deployed in both regions instead (either as single or HA appliances).

This pattern allows on-premise traffic to flow into a set of firewalls prior to routing traffic to IBM Cloud’s PowerVS and Virtual Private Cloud (VPC) environments. It is used to integrate on-premises access with classic infrastructure and Power Virtual Server workloads within the IBM Cloud.

By connecting two IBM Cloud regions, this pattern deploys the basic network infrastructure required to build a disaster recovery solution for IBM Cloud Classic and PowerVS workloads.

Note that some additional configuration will be needed on the classic gateway appliance(s) and on the DNS server, bastion and proxy VSIs to make this pattern operational (see the Post deployment tasks section).

Also note that PowerVS Cloud Connections are only available in a limited number of regions as they are being replaced by the Power Edge Router.

![Hybrid cloud networking classic across two regions](classic-VRF-two_regions.svg)

## Pre-requisites

- an [IBM Cloud account](https://cloud.ibm.com/registration)
- an [IBM Cloud classic API key](https://cloud.ibm.com/docs/account?topic=account-classic_keys&interface=ui) must exist and the account associated to it must have the correct IAM permissions
- an [IBM Cloud API key](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui) must exist and the account associated to it must have the correct IAM permissions
- An [SSH key](https://cloud.ibm.com/docs/ssh-keys?topic=ssh-keys-adding-an-ssh-key) must already exist in the IBM Cloud classic infrastructure account
- If not intending to use a new [Virtual Router Appliance (VRA)](https://cloud.ibm.com/docs/virtual-router-appliance?topic=virtual-router-appliance-getting-started-vra) gateway appliance, an [IBM Cloud gateway appliance](https://cloud.ibm.com/docs/gateway-appliance?topic=gateway-appliance-getting-started-ga) must be provisionned before running this automation (the private IP of the existing gateway appliance is a required parameter if not provisioning a VRA through this automation)
- [Virtual Routing and Forwarding (VRF)](https://cloud.ibm.com/docs/account?topic=account-vrf-service-endpoint&interface=ui) needs to be enabled in the classic environment

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.77.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.79.2 |
| <a name="provider_ibm.ibm-pi-region-1"></a> [ibm.ibm-pi-region-1](#provider\_ibm.ibm-pi-region-1) | 1.79.2 |
| <a name="provider_ibm.ibm-pi-region-2"></a> [ibm.ibm-pi-region-2](#provider\_ibm.ibm-pi-region-2) | 1.79.2 |
| <a name="provider_ibm.ibm_classic_region-2"></a> [ibm.ibm\_classic\_region-2](#provider\_ibm.ibm\_classic\_region-2) | 1.79.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_create_sgr_rule"></a> [create\_sgr\_rule](#module\_create\_sgr\_rule) | terraform-ibm-modules/security-group/ibm | ~>2.6.2 |

## Resources

| Name | Type |
|------|------|
| [ibm_cis.cis_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cis) | resource |
| [ibm_compute_vm_instance.bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.dns_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.jump_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_compute_vm_instance.proxy_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/compute_vm_instance) | resource |
| [ibm_cos_bucket.cos_bucket_regional_smart](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cos_bucket) | resource |
| [ibm_cos_bucket.cos_bucket_regional_smart_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/cos_bucket) | resource |
| [ibm_is_subnet.subnet1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet) | resource |
| [ibm_is_virtual_endpoint_gateway.vpc_region_2_vpe](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_virtual_endpoint_gateway) | resource |
| [ibm_is_vpc.vpc](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_vpc) | resource |
| [ibm_is_vpc_address_prefix.vpc_address_prefix](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_vpc_address_prefix) | resource |
| [ibm_network_gateway.gateway_ha](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway) | resource |
| [ibm_network_gateway.gateway_ha_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway) | resource |
| [ibm_network_gateway.gateway_single](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway) | resource |
| [ibm_network_gateway.gateway_single_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_data_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_data_vlan_association_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_infra_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_infra_vlan_association_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_management_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.ha_gateway_management_vlan_association_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_data_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_data_vlan_association_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_infra_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_infra_vlan_association_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_management_vlan_association](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_gateway_vlan_association.single_gateway_management_vlan_association_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_gateway_vlan_association) | resource |
| [ibm_network_vlan.data_vlan](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.data_vlan_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.infra_vlan](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.infra_vlan_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.management_vlan](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_network_vlan.management_vlan_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/network_vlan) | resource |
| [ibm_pi_cloud_connection.region_1_cloud_connection_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_pi_cloud_connection.region_1_cloud_connection_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_pi_cloud_connection.region_2_cloud_connection_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_pi_cloud_connection.region_2_cloud_connection_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_cloud_connection) | resource |
| [ibm_pi_network.power_workspace_region_1_subnet_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_network.power_workspace_region_2_subnet_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_network) | resource |
| [ibm_pi_workspace.powervs_workspace_region_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_workspace) | resource |
| [ibm_pi_workspace.powervs_workspace_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_workspace) | resource |
| [ibm_resource_group.resource_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_group) | resource |
| [ibm_resource_instance.cos_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.cos_instance_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_security_group.sg_bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_dns_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_jump_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group.sg_proxy_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group) | resource |
| [ibm_security_group_rule.allow_all_egress_bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_dns_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_jump_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_all_egress_proxy_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_dns_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_jump_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_proxy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_22_proxy_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_53_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_tcp_53_dns_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_udp_53_dns_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_security_group_rule.allow_ingress_udp_53_dns_server_region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/security_group_rule) | resource |
| [ibm_tg_connection.tg1-connection-classic-region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.tg2-connection-classic-region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.tg2_connection-powevs-from-region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.tg2_connection-vpc](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.tg3-connection-gre-powervs-from-region_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.tg3_connection-powevs-from-region_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_connection) | resource |
| [ibm_tg_gateway.tg-region_2-1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_gateway) | resource |
| [ibm_tg_gateway.tg-region_2-2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_gateway) | resource |
| [ibm_tg_gateway.tg-region_2-3](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/tg_gateway) | resource |
| [ibm_compute_ssh_key.classic_ssh_key_name](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/compute_ssh_key) | data source |
| [ibm_dl_gateway.region_1_cloud_connection_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/dl_gateway) | data source |
| [ibm_dl_gateway.region_2_cloud_connection_1](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/dl_gateway) | data source |
| [ibm_dl_gateway.region_2_cloud_connection_2](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/dl_gateway) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_basename"></a> [basename](#input\_basename) | Prefix to use for naming the resources deployed by this automation | `string` | `"terraform"` | no |
| <a name="input_bastion_os"></a> [bastion\_os](#input\_bastion\_os) | Operating system to use for the bastion VSI. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| <a name="input_bastion_private_only"></a> [bastion\_private\_only](#input\_bastion\_private\_only) | Whether or not the bastion VSI need to only have private connectivity | `bool` | `"true"` | no |
| <a name="input_cis_plan"></a> [cis\_plan](#input\_cis\_plan) | CIS plan to use. The list of available plans can be found using the ibmcloud cli command 'ibmcloud catalog service internet-svcs' | `string` | `"standard-next"` | no |
| <a name="input_classic_datacenter"></a> [classic\_datacenter](#input\_classic\_datacenter) | IBM Cloud classic availability zone name (in lower case) where to deploy the resources. A list of IBM Cloud classic availability zones can be found here: <https://cloud.ibm.com/docs/overview?topic=overview-locations#data-centers> | `string` | n/a | yes |
| <a name="input_classic_datacenter_region_2"></a> [classic\_datacenter\_region\_2](#input\_classic\_datacenter\_region\_2) | IBM Cloud classic availability zone name (in lower case) where to deploy the resources in the 2nd region. A list of IBM Cloud classic availability zones can be found here: <https://cloud.ibm.com/docs/overview?topic=overview-locations#data-centers> | `string` | n/a | yes |
| <a name="input_classic_domain"></a> [classic\_domain](#input\_classic\_domain) | Domain name to use for the compute resources deployed in classic | `string` | `"ibmcloud.private"` | no |
| <a name="input_classic_domain_region_2"></a> [classic\_domain\_region\_2](#input\_classic\_domain\_region\_2) | Domain name to use for the compute resources deployed in classic in the 2nd region. | `string` | `"ibmcloud.private"` | no |
| <a name="input_classic_gateway_private_only"></a> [classic\_gateway\_private\_only](#input\_classic\_gateway\_private\_only) | If deploying the classic VRA gateway, whether to deploy it with private only connectivity | `bool` | `false` | no |
| <a name="input_classic_gateway_private_only_region_2"></a> [classic\_gateway\_private\_only\_region\_2](#input\_classic\_gateway\_private\_only\_region\_2) | If deploying the classic VRA gateway in the 2nd region, whether to deploy it with private only connectivity. | `bool` | `false` | no |
| <a name="input_classic_ssh_key_name"></a> [classic\_ssh\_key\_name](#input\_classic\_ssh\_key\_name) | Name of the SSH key to use when provisioning the VSIs in order to be able to access them later. The SSH key must already exist in the account before deploying the resources | `string` | n/a | yes |
| <a name="input_cos_bucket_name"></a> [cos\_bucket\_name](#input\_cos\_bucket\_name) | Name for the regional COS bucket. Note that the COS bucket will be deployed in the same region as the classic gateway/virtual server instances if this is a multizone region or in the closest multi-zone region (eu-de for par01, ams03 and mil01, jap-osa for sng01 and che01, ca-tor for mon01, us-south for sjc03 and sjc04) | `string` | `"regional-cos-bucket"` | no |
| <a name="input_cos_bucket_name_region_2"></a> [cos\_bucket\_name\_region\_2](#input\_cos\_bucket\_name\_region\_2) | Name for the regional COS bucket in the 2nd region. Note that the COS bucket will be deployed in the same region as the classic gateway/virtual server instances if this is a multizone region or in the closest multi-zone region (eu-de for par01, ams03 and mil01, jap-osa for sng01 and che01, ca-tor for mon01, us-south for sjc03 and sjc04) | `string` | `"regional-cos-bucket-region-2"` | no |
| <a name="input_cos_plan"></a> [cos\_plan](#input\_cos\_plan) | COS instance plan to use (standard or lite) | `string` | `"standard"` | no |
| <a name="input_cos_plan_region_2"></a> [cos\_plan\_region\_2](#input\_cos\_plan\_region\_2) | COS instance plan to use in the 2nd region. (standard or lite) | `string` | `"standard"` | no |
| <a name="input_cos_storage_class"></a> [cos\_storage\_class](#input\_cos\_storage\_class) | COS storage class to use (standard, smart, cold or vault) | `string` | `"smart"` | no |
| <a name="input_cos_storage_class_region_2"></a> [cos\_storage\_class\_region\_2](#input\_cos\_storage\_class\_region\_2) | COS storage class to use in the 2nd region. (standard, smart, cold or vault) | `string` | `"smart"` | no |
| <a name="input_deploy_gateway_appliance"></a> [deploy\_gateway\_appliance](#input\_deploy\_gateway\_appliance) | Whether or not to deploy the VRA classic gateway appliance | `bool` | `false` | no |
| <a name="input_deploy_gateway_appliance_region_2"></a> [deploy\_gateway\_appliance\_region\_2](#input\_deploy\_gateway\_appliance\_region\_2) | Whether or not to deploy the VRA classic gateway appliance in the 2nd region. | `bool` | `false` | no |
| <a name="input_deploy_region_2"></a> [deploy\_region\_2](#input\_deploy\_region\_2) | A flag whether or not to deploy the 2nd regional infrastructure. | `bool` | `false` | no |
| <a name="input_dns_server_os"></a> [dns\_server\_os](#input\_dns\_server\_os) | Operating system to use for the bastion VSI. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| <a name="input_dns_server_os_region_2"></a> [dns\_server\_os\_region\_2](#input\_dns\_server\_os\_region\_2) | Operating system to use for the bastion VSI in the 2nd region.. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| <a name="input_existing_classic_gateway_private_ip"></a> [existing\_classic\_gateway\_private\_ip](#input\_existing\_classic\_gateway\_private\_ip) | Provide the private IPv4 address of an existing IBM Cloud Classic Gateway. This is not needed if deploying a new VRA classic gateway through this automation | `string` | n/a | yes |
| <a name="input_existing_classic_gateway_private_ip_region_2"></a> [existing\_classic\_gateway\_private\_ip\_region\_2](#input\_existing\_classic\_gateway\_private\_ip\_region\_2) | Provide the private IPv4 address of an existing IBM Cloud Classic Gateway in the 2nd region. This is not needed if deploying a new VRA classic gateway through this automation. | `string` | n/a | yes |
| <a name="input_gateway_appliance_network_speed"></a> [gateway\_appliance\_network\_speed](#input\_gateway\_appliance\_network\_speed) | Maximum network speed to use for the gateway appliance (1000 or 10000, 1000 = 1Gbps) | `string` | `1000` | no |
| <a name="input_gateway_appliance_network_speed_region_2"></a> [gateway\_appliance\_network\_speed\_region\_2](#input\_gateway\_appliance\_network\_speed\_region\_2) | Maximum network speed to use for the gateway appliance in the 2nd region. (1000 or 10000, 1000 = 1Gbps) | `string` | `1000` | no |
| <a name="input_gateway_ha_enabled"></a> [gateway\_ha\_enabled](#input\_gateway\_ha\_enabled) | If deploying the VRA classic gateway appliance, whether or not to deploy it in High Availability mode | `bool` | `"false"` | no |
| <a name="input_gateway_ha_enabled_region_2"></a> [gateway\_ha\_enabled\_region\_2](#input\_gateway\_ha\_enabled\_region\_2) | If deploying the VRA classic gateway appliance in the 2nd region, whether or not to deploy it in High Availability mode | `bool` | `"false"` | no |
| <a name="input_gateway_memory"></a> [gateway\_memory](#input\_gateway\_memory) | Amount of memory to use for the classic gateway appliance | `string` | `"32"` | no |
| <a name="input_gateway_memory_region_2"></a> [gateway\_memory\_region\_2](#input\_gateway\_memory\_region\_2) | Amount of memory to use for the classic gateway appliance in the 2nd region. | `string` | `"32"` | no |
| <a name="input_gateway_name"></a> [gateway\_name](#input\_gateway\_name) | Name to use for the VRA classic gateway appliance (only used if deploying the VRA classic gateway appliance) | `string` | `"gateway-appliance"` | no |
| <a name="input_gateway_name_region_2"></a> [gateway\_name\_region\_2](#input\_gateway\_name\_region\_2) | Name to use for the VRA classic gateway appliance in the 2nd region. (only used if deploying the VRA classic gateway appliance) | `string` | `"gateway-appliance"` | no |
| <a name="input_grea_tg1_local_gateway_ip_tunnel_1"></a> [grea\_tg1\_local\_gateway\_ip\_tunnel\_1](#input\_grea\_tg1\_local\_gateway\_ip\_tunnel\_1) | Private IP address of the existing Classic Gateway in region 2 | `string` | `"172.16.4.1"` | no |
| <a name="input_grea_tg1_local_gateway_ip_tunnel_2"></a> [grea\_tg1\_local\_gateway\_ip\_tunnel\_2](#input\_grea\_tg1\_local\_gateway\_ip\_tunnel\_2) | Private IP address of the existing Classic Gateway in region 2 | `string` | `"172.16.5.1"` | no |
| <a name="input_grea_tg1_local_tunnel_ip_tunnel_1"></a> [grea\_tg1\_local\_tunnel\_ip\_tunnel\_1](#input\_grea\_tg1\_local\_tunnel\_ip\_tunnel\_1) | Local GRE Tunnel IP for tunnel 1 of grea on transit gateway 1 | `string` | `"172.16.4.5"` | no |
| <a name="input_grea_tg1_local_tunnel_ip_tunnel_2"></a> [grea\_tg1\_local\_tunnel\_ip\_tunnel\_2](#input\_grea\_tg1\_local\_tunnel\_ip\_tunnel\_2) | Local GRE Tunnel IP for tunnel 2 of grea on transit gateway 1 | `string` | `"172.16.5.5"` | no |
| <a name="input_grea_tg1_remote_tunnel_ip_tunnel_1"></a> [grea\_tg1\_remote\_tunnel\_ip\_tunnel\_1](#input\_grea\_tg1\_remote\_tunnel\_ip\_tunnel\_1) | Remote GRE Tunnel IP for tunnel 1 of grea on transit gateway 1 | `string` | `"172.16.4.6"` | no |
| <a name="input_grea_tg1_remote_tunnel_ip_tunnel_2"></a> [grea\_tg1\_remote\_tunnel\_ip\_tunnel\_2](#input\_grea\_tg1\_remote\_tunnel\_ip\_tunnel\_2) | Remote GRE Tunnel IP for tunnel 2 grea on transit gateway 1 | `string` | `"172.16.5.6"` | no |
| <a name="input_grec_tg2_local_gateway_ip"></a> [grec\_tg2\_local\_gateway\_ip](#input\_grec\_tg2\_local\_gateway\_ip) | Private IP address of the existing Classic Gateway in region 2 | `string` | `"172.16.3.1"` | no |
| <a name="input_grec_tg2_local_tunnel_ip"></a> [grec\_tg2\_local\_tunnel\_ip](#input\_grec\_tg2\_local\_tunnel\_ip) | Local GRE Tunnel IP for grec on transit gateway 2 | `string` | `"172.16.3.5"` | no |
| <a name="input_grec_tg2_remote_tunnel_ip"></a> [grec\_tg2\_remote\_tunnel\_ip](#input\_grec\_tg2\_remote\_tunnel\_ip) | Remote GRE Tunnel IP for grec on transit gateway 2 | `string` | `"172.16.3.6"` | no |
| <a name="input_hostname_gateway_1"></a> [hostname\_gateway\_1](#input\_hostname\_gateway\_1) | Name to use for the first VRA classic gateway appliance instance (only used if deploying the VRA classic gateway appliance) | `string` | `"gateway01"` | no |
| <a name="input_hostname_gateway_1_region_2"></a> [hostname\_gateway\_1\_region\_2](#input\_hostname\_gateway\_1\_region\_2) | Name to use for the first VRA classic gateway appliance instance in the 2nd region. (only used if deploying the VRA classic gateway appliance) | `string` | `"gateway01"` | no |
| <a name="input_hostname_gateway_2"></a> [hostname\_gateway\_2](#input\_hostname\_gateway\_2) | Name to use for the second classic gateway appliance instance (only used if deploying the classic gateway appliance in HA mode) | `string` | `"gateway02"` | no |
| <a name="input_hostname_gateway_2_region_2"></a> [hostname\_gateway\_2\_region\_2](#input\_hostname\_gateway\_2\_region\_2) | Name to use for the second classic gateway appliance instance in the 2nd region. (only used if deploying the classic gateway appliance in HA mode) | `string` | `"gateway02"` | no |
| <a name="input_iaas_classic_api_key"></a> [iaas\_classic\_api\_key](#input\_iaas\_classic\_api\_key) | IBM Cloud classic API key used to provision the classic IBM Cloud resources | `string` | n/a | yes |
| <a name="input_iaas_classic_username"></a> [iaas\_classic\_username](#input\_iaas\_classic\_username) | IBM Cloud classic user name used to provision the classic IBM Cloud resources. The classic username will usually be in the form of <ACCOUNT\_ID>\_<EMAIL\_ADDRESS@email.com> | `string` | n/a | yes |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | IBM Cloud API key used to provision the non-classic IBM Cloud resources | `string` | n/a | yes |
| <a name="input_instance_type_bastion"></a> [instance\_type\_bastion](#input\_instance\_type\_bastion) | Instance type to use for the bastion VSI. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| <a name="input_instance_type_dns_server"></a> [instance\_type\_dns\_server](#input\_instance\_type\_dns\_server) | Instance type to use for the DNS server VSI. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| <a name="input_instance_type_dns_server_region_2"></a> [instance\_type\_dns\_server\_region\_2](#input\_instance\_type\_dns\_server\_region\_2) | Instance type to use for the DNS server VSI in the 2nd region. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| <a name="input_instance_type_jump_server_region_2"></a> [instance\_type\_jump\_server\_region\_2](#input\_instance\_type\_jump\_server\_region\_2) | Instance type to use for the jump server VSI in the 2nd region. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| <a name="input_instance_type_proxy"></a> [instance\_type\_proxy](#input\_instance\_type\_proxy) | Instance type to use for the proxy VSI. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| <a name="input_instance_type_proxy_region_2"></a> [instance\_type\_proxy\_region\_2](#input\_instance\_type\_proxy\_region\_2) | Instance type to use for the proxy VSI in the 2nd region. For a list of available instance profiles, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest/getCreateObjectOptions.json> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"B1_2X4X25"` | no |
| <a name="input_jump_server_os_region_2"></a> [jump\_server\_os\_region\_2](#input\_jump\_server\_os\_region\_2) | Operating system to use for the jump server VSI in the 2nd region. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| <a name="input_jump_server_private_only_region_2"></a> [jump\_server\_private\_only\_region\_2](#input\_jump\_server\_private\_only\_region\_2) | Whether or not the jump server VSI need to only have private connectivity in the 2nd region. | `bool` | `"true"` | no |
| <a name="input_pi_region_1_connection_1_gre_cidr"></a> [pi\_region\_1\_connection\_1\_gre\_cidr](#input\_pi\_region\_1\_connection\_1\_gre\_cidr) | network CIDR to be used for configuring the GRE tunnel of the first PowerVS workspace cloud connection, refer to <https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-exampl> to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP | `string` | `"172.16.0.0/29"` | no |
| <a name="input_pi_region_2_connection_1_gre_cidr"></a> [pi\_region\_2\_connection\_1\_gre\_cidr](#input\_pi\_region\_2\_connection\_1\_gre\_cidr) | Network CIDR to be used for configuring the GRE tunnel of the first PowerVS workspace cloud connection in the 2nd region, refer to <https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#gre-configuration-example> to understand which IP address of this range will be used as PowerVS source IP, PowerVS tunnel IP and which IP address should be used as Classic Gateway tunnel IP | `string` | `"172.16.0.8/29"` | no |
| <a name="input_pi_resource_group_name"></a> [pi\_resource\_group\_name](#input\_pi\_resource\_group\_name) | Name of the pre-existing resource group where the PowerVS worskspace will be created | `string` | `"terraform"` | no |
| <a name="input_pi_workspace_cloud_connection_speed"></a> [pi\_workspace\_cloud\_connection\_speed](#input\_pi\_workspace\_cloud\_connection\_speed) | Define the speed of the PowerVS Cloud connections to the classic environment (10, 50, 100, 200, 500, 1000, 2000, 5000 with 1000 = 1Gbps). | `string` | `"1000"` | no |
| <a name="input_pi_workspace_cloud_connection_speed_region_2"></a> [pi\_workspace\_cloud\_connection\_speed\_region\_2](#input\_pi\_workspace\_cloud\_connection\_speed\_region\_2) | Define the speed of the PowerVS Cloud connections to the classic environment in the 2nd region. (10, 50, 100, 200, 500, 1000, 2000, 5000 with 1000 = 1Gbps) | `string` | `"1000"` | no |
| <a name="input_pi_workspace_name_region_1"></a> [pi\_workspace\_name\_region\_1](#input\_pi\_workspace\_name\_region\_1) | Name of the PowerVS workspace to create | `string` | `"production-workspace"` | no |
| <a name="input_pi_workspace_name_region_2"></a> [pi\_workspace\_name\_region\_2](#input\_pi\_workspace\_name\_region\_2) | Name of the PowerVS workspace to create in the 2nd region. | `string` | `"production-workspace-2"` | no |
| <a name="input_pi_workspace_region_1_subnet_1"></a> [pi\_workspace\_region\_1\_subnet\_1](#input\_pi\_workspace\_region\_1\_subnet\_1) | Subnet to use in the powerVS workspace in CIDR notation | `string` | `"192.168.0.0/24"` | no |
| <a name="input_pi_workspace_region_2_subnet_1"></a> [pi\_workspace\_region\_2\_subnet\_1](#input\_pi\_workspace\_region\_2\_subnet\_1) | Subnet to use in the powerVS workspace in CIDR notation in the 2nd region. | `string` | `"192.168.0.0/24"` | no |
| <a name="input_pi_zone_region_1"></a> [pi\_zone\_region\_1](#input\_pi\_zone\_region\_1) | PowerVS availability zone to use, must be che01 or mon01 as the other Powervs regions are all PER enabled and do not support cloud connections | `string` | n/a | yes |
| <a name="input_pi_zone_region_2"></a> [pi\_zone\_region\_2](#input\_pi\_zone\_region\_2) | PowerVS availability zone to use in the 2nd region, must be che01, mon01 or lon04 as the other Powervs regions are all PER enabled and do not support cloud connections | `string` | n/a | yes |
| <a name="input_proxy_os"></a> [proxy\_os](#input\_proxy\_os) | Operating system to use for the proxy VSI. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| <a name="input_proxy_os_region_2"></a> [proxy\_os\_region\_2](#input\_proxy\_os\_region\_2) | Operating system to use for the proxy VSI in the 2nd region. For a list of available OSes, use the <https://api.softlayer.com/rest/v3/SoftLayer_Virtual_Guest_Block_Device_Template_Group/getVhdImportSoftwareDescriptions.json?objectMask=referenceCode> ibmcloud API. See <https://sldn.softlayer.com/article/authenticating-softlayer-api/> regarding how to access the API | `string` | `"UBUNTU_24_64"` | no |
| <a name="input_total_ipv4_address_count"></a> [total\_ipv4\_address\_count](#input\_total\_ipv4\_address\_count) | The total number of IPv4 addresses. | `string` | `"256"` | no |
| <a name="input_vpc_address_prefix"></a> [vpc\_address\_prefix](#input\_vpc\_address\_prefix) | The address prefix for the  VPC zone. | `string` | `"192.168.10.0/18"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The subnet IP range for the VPC, needs to belong to the defined address prefix. | `string` | `"192.168.10.0/24"` | no |
| <a name="input_vpc_name_region_2"></a> [vpc\_name\_region\_2](#input\_vpc\_name\_region\_2) | Name of the VPC to create. | `string` | `"production-vpc"` | no |
| <a name="input_vpc_zone"></a> [vpc\_zone](#input\_vpc\_zone) | The zone in which the VPC will be deployed (e.g., ca-tor-1, eu-gb-1, us-south-1). | `string` | `"ca-mon-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region2_cloud_connet_crn"></a> [region2\_cloud\_connet\_crn](#output\_region2\_cloud\_connet\_crn) | n/a |

## Post deployment tasks

- if there was a pre-existing classic gateway appliance, associate the VLANs created by the automation to it
- finish the configuration of the classic gateway appliance (VLANs configuration, firewall rules configuration)
- add a second [cloud connection](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-cloud-connections#create-cloud-connections) in the PowerVS workspace created by the automation for redundancy and configure GRE on it
- configure two GRE tunnel interfaces on the classic gateway appliance(s) to terminate the PowerVS to classic GRE tunnels and configure BGP over these tunnels (labelled as GREc on the diagram)
- install and configure the DNS server, proxy and bastion softwares on the VSIs created by the automation
- order two [direct link](/docs/dl?topic=dl-get-started-with-ibm-cloud-dl) from on-prem to the environment
- once the direct links are operational, configure two GRE tunnels between the classic gateway appliance and the on premises customer router (labelled as GREa on the diagram) and configure BGP over these GRE tunnels.
- **configure the Classic gateway appliances in the secondary region to strip the BGP AS numbers (ASN) from the routes learnt from a transit gateway before they are re-advertised to another transit gateway. BGP route-maps can be used to achieve this. This is needed because in IBM Cloud all the transit gateway router located in a given availability zone use the same BGP AS number, which will prevent re-advertising them as is between different transit gateway routers located in the same availability zone (this will cause issues due to the default transit gateway zonal routing preference)**
- adjust the [security groups rules](https://cloud.ibm.com/docs/security-groups?topic=security-groups-creating-security-groups) of the VSIs created by the automation as needed.
- install and configure the DNS server, proxy and bastion softwares on the VSIs created by the automation
- Optionally - provision an IBM Cloud Load Balancer or a Citrix VPX load balancer from the IBM cloud portal if needed
