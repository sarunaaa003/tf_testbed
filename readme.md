Project for MarkMonitor Infrastructure Terraform
================================================

Strongly recommend use of editor with Terraform / HCL syntax highlighting.


Switch for Mesos in use:
in `mesos/settings/mesos.tfvars`

```
master_count = 3
member_count = 5
ansible_count = 1
registry_count = 1

instance_type = "m4.2xlarge"
instance_type_member = "m4.4xlarge"
instance_type_util = "m4.xlarge"
```

Initial Setup:
------------------------------
Create S3 Bucket `mm-ops-devshrd`
Create folders in bucket:
```
  DEVMENT
  QATESTG
  DEVSHRD
```
Configure DEVSHRD terraform for remote:
```
$ cd devshrd
$ terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-devshrd" \
    -backend-config="key=DEVSHRD/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=<your profile>" \
    # use if not ~/.aws/credentials
    # -backend-config="shared_credentials_file=<your aws creds file>"
```
Configure DEVMENT terraform for remote:
```
$ cd devment
$ terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-devshrd" \
    -backend-config="key=DEVMENT/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=<your profile>" \
    # use if not ~/.aws/credentials
    # -backend-config="shared_credentials_file=<your aws creds file>"
```
Configure QATESTG terraform for remote:
```
$ cd qatestg
$ terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-devshrd" \
    -backend-config="key=QATESTG/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=<your profile>" \
    # use if not ~/.aws/credentials
    # -backend-config="shared_credentials_file=<your aws creds file>"
```
Configure Mesos QATESTG for remote:
```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-devshrd" \
    -backend-config="key=/APP/mesos/QATESTG/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=<your profile>" \
```
Configure Mesos QATESTG for remote:
```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-devshrd" \
    -backend-config="key=/APP/mesos/DVCMSVS/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=<your profile>" \
```

Configure Squid for remote:
```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-devshrd" \
    -backend-config="key=/APP/squid/DVCMSVS/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=<your profile>" \
```

Configure prdshrd for remote:
```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-prdshrd" \
    -backend-config="key=PRDSHRD/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=mm-prod"
```

To use:
----------------

Clone to somewhere safe.

```
$ unset AWS_ACCESS_KEY
$ unset AWS_SECRET_KEY
$ cp settings/secrets-template.tfvars settings/secrets.tfvars
$ chmod 600 settings/secrets.tfvars
```

Populate secrets.tfvars
Update the following to consume the proper region

```
$ cd devshrd
$ terraform plan \
  -var-file="../settings/secrets-dev.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/devshrd.tfvars" \
  -var-file="../settings/dvcmsvs.tfvars"
```

To build the base environment and vpcs DEVSHRD:
```
terraform apply \
  -var-file="../settings/secrets-dev.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/devshrd.tfvars" \
  -var-file="../settings/dvcmsvs.tfvars"
```

To build DEVMENT:
```
terraform apply \
  -var-file="../settings/secrets-dev.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/devshrd.tfvars" \
  -var-file="../settings/devment.tfvars"
```

To build QATESTG:
```
terraform apply \
  -var-file="../settings/secrets-dev.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/devshrd.tfvars" \
  -var-file="../settings/qatestg.tfvars"
```

To build MESOS:
```
terraform apply \
  -var-file="../settings/secrets-dev.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/devshrd.tfvars" \
  -var-file="../settings/qatestg.tfvars" \
  -var-file="settings/mesos.tfvars"
```

To build PRCMSVS:
```
terraform plan -var-file="../settings/secrets-prod.tfvars" -var-file="../settings/shared.tfvars" -var-file="../settings/prdshrd.tfvars" -var-file="../settings/prcmsvs.tfvars"
```

Todo:
----------------


Notes:
----------------------
Modules are vendored from http://blog.lusis.org/blog/2015/10/12/terraform-modules-for-fun-and-profit/

When you use modules, the first thing you’ll have to do is terraform get. This pulls modules into the .terraform directory. Once you do that, unless you do another terraform get -update=true, you’ve essentially vendored those modules. This is nice as you know an upstream change won’t immediately invalidate and destroy your infra.

Put these places

```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-prdshrd" \
    -backend-config="key=STAGING/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=mm-prod"

terraform plan \
  -var-file="../settings/secrets-prod.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/prdshrd.tfvars" \
  -var-file="../settings/staging.tfvars"

terraform apply \
  -var-file="../settings/secrets-prod.tfvars" \
  -var-file="../settings/shared.tfvars" \
  -var-file="../settings/prdshrd.tfvars" \
  -var-file="../settings/staging.tfvars"

  terraform remote config \
      -backend=s3 \
      -backend-config="bucket=mm-ops-prdshrd" \
      -backend-config="key=PRDCTON/terraform.tfstate" \
      -backend-config="region=us-west-1" \
      -backend-config="profile=mm-prod"

  terraform plan \
    -var-file="../settings/secrets-prod.tfvars" \
    -var-file="../settings/shared.tfvars" \
    -var-file="../settings/prdshrd.tfvars" \
    -var-file="../settings/prdcton.tfvars"

  terraform apply \
    -var-file="../settings/secrets-prod.tfvars" \
    -var-file="../settings/shared.tfvars" \
    -var-file="../settings/prdshrd.tfvars" \
    -var-file="../settings/prdcton.tfvars"

terraform remote config \
  -backend=s3 \
  -backend-config="bucket=mm-ops-prdshrd" \
  -backend-config="key=STAGING/terraform.tfstate" \
  -backend-config="region=us-west-1" \
  -backend-config="profile=mm-prod"

  terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mm-ops-prdshrd" \
    -backend-config="key=APP/mesos/STAGING/terraform.tfstate" \
    -backend-config="region=us-west-1" \
    -backend-config="profile=mm-prod"

    terraform remote config \
      -backend=s3 \
      -backend-config="bucket=mm-ops-prdshrd" \
      -backend-config="key=APP/mesos/PRDCTON/terraform.tfstate" \
      -backend-config="region=us-west-1" \
      -backend-config="profile=mm-prod"
```


Production and Staging environments require the following peers:

CMS1, DEV1, POC1

These must be accepted manually from DEVSHRD account. Then the following must happen:

Create route entry for target vpc to corresponding peer

Create security group exception for inbound from corresponding cidr for CMS1, DEV1, POC1 SG's.


ALERT
need to associate dvcmsvs public and private sub
