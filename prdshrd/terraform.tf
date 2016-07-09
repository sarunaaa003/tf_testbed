# Kick it off
provider "aws" {
    region                  = "${var.region}"
    shared_credentials_file = "${var.shared_credentials_file}"
    profile                 = "${var.aws_profile}"
}

resource "terraform_remote_state" "SHARED_STATE" {
  backend = "s3"
  config = {
    bucket                  = "${var.shared_tf_s3_bucket}"
    region                  = "${var.region}"
    key                     = "${var.shared_tf_s3_key}"
    profile                 = "${var.shared_aws_profile}"
  }
}
