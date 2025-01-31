locals {
  ibm_powervs_zone_region_map = {
    "lon04"    = "lon"
    "lon06"    = "lon"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "eu-es-1"  = "eu-es"
    "eu-es-2"  = "eu-es"
    "tor01"    = "tor"
    "mon01"    = "mon"
    "che01"    = "che"
    "osa21"    = "osa"
    "tok04"    = "tok"
    "syd04"    = "syd"
    "syd05"    = "syd"
    "sao01"    = "sao"
    "sao04"    = "sao"
    "us-south" = "us-south"
    "dal10"    = "us-south"
    "dal12"    = "us-south"
    "dal14"    = "us-south"
    "us-east"  = "us-east"
    "wdc06"    = "us-east"
    "wdc07"    = "us-east"
    "mad02"    = "mad"
    "mad04"    = "mad"
  }

  ibm_powervs_zone_cloud_region_map = {
    "syd04"    = "au-syd"
    "syd05"    = "au-syd"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "eu-es-1"  = "eu-es"
    "eu-es-2"  = "eu-es"
    "lon04"    = "eu-gb"
    "lon06"    = "eu-gb"
    "tok04"    = "jp-tok"
    "tor01"    = "ca-tor"
    "che01"    = "in-che"
    "osa21"    = "jp-osa"
    "sao01"    = "br-sao"
    "sao04"    = "br-sao"
    "mon01"    = "ca-tor"
    "us-south" = "us-south"
    "dal10"    = "us-south"
    "dal12"    = "us-south"
    "dal14"    = "us-south"
    "us-east"  = "us-east"
    "wdc06"    = "us-east"
    "wdc07"    = "us-east"
    "mad02"    = "eu-es"
    "mad04"    = "eu-es"
  }

classic_region = {
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

provider "ibm" {
    iaas_classic_api_key = var.iaas_classic_api_key
    iaas_classic_username = var.iaas_classic_username
    ibmcloud_api_key = var.ibmcloud_api_key
    region = lookup(local.classic_region, var.classic_datacenter, null)
    zone = var.classic_datacenter
    }

provider "ibm" {
    alias = "ibm-pi-region-1"
    ibmcloud_api_key = var.ibmcloud_api_key
    region = lookup(local.ibm_powervs_zone_region_map, var.pi_zone_region_1, null)
    zone = var.pi_zone_region_1
    }