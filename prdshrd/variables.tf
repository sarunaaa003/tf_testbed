# provider core reqs
variable "account_id" {}
variable "aws_profile" {}
variable "shared_credentials_file" {}

# environemnt
variable "account_name" {}
variable "environment" {}
variable "region" {}
variable "region_azs" {}

# remote states
variable "tf_s3_bucket" {}
variable "tf_s3_key" {}
variable "shared_account_id" {}
variable "shared_tf_s3_bucket" {}
variable "shared_tf_s3_key" {}
variable "shared_aws_profile" {}

# vpn
#variable "on_prem_gw" {}

# convenience
variable "keypair" {}
variable "generic_owner" {}
variable "ami" {}

# cidrs in use
variable "cidr_prdcton" {}
variable "cidr_staging" {}
variable "cidr_qatestg" {}
variable "cidr_devment" {}
variable "cidr_prdshrd" {}
variable "cidr_devshrd" {}
variable "cidr_vpn_110" {}
variable "cidr_vpn_111" {}
variable "cidr_vpn_112" {}
variable "cidr_vpn_cgw" {}
variable "cidr_vpn_Virtusa" {}
variable "cidr_cfengine" {}
variable "cidr_corp_docker" {}

# subnet scoping
variable "cidr_block_public" {}
variable "cidr_block_private" {}
