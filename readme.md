

terraform remote config -backend=s3 -backend-config="bucket=tf-testbed" -backend-config="key=PRDSHRD/terraform.tfstate" -backend-config="region=us-east-1"



terraform plan -var-file="../settings/secrets-prd.tfvars" -var-file="../settings/shared.tfvars" -var-file="../settings/prdshrd.tfvars"
