account_name = "PRDSHRD"
environment = "PRDCTON"

# remote states
tf_s3_bucket = "tf-testbed"
tf_s3_key = "PRDCTON/terraform.tfstate"
tf_s3_parent_key = "PRDSHRD/terraform.tfstate"

# subnets
cidr_block_public = "10.200.0.0/20,10.200.16.0/20,10.200.32.0/20,10.200.48.0/20"
cidr_block_private = "10.200.128.0/20,10.200.144.0/20,10.200.160.0/20,10.200.176.0/20"
