# Common creation
resource "aws_vpc" "VPC_COMMON" {
  cidr_block           = "${var.cidr_prdshrd}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags {
    "Terraform"        = "true"
    "Name"             = "${var.environment}01"
    "Owner"            = "${var.generic_owner}"
  }
}
# DHCP Option Set to be enabled in the event of a DNS Bind as a forwarder
#resource "aws_vpc_dhcp_options" "DHCP_COMMON" {
#  domain_name = "aws.mm-corp.net"
#  domain_name_servers = ["10.205.137.247","10.205.152.32"]
#  ntp_servers = ["10.205.137.247"]
#  tags {
#    "Terraform"        = "true"
#    "Name"             = "COMMON"
#    "Owner"            = "${var.generic_owner}"
#  }
#}
#resource "aws_vpc_dhcp_options_association" "DHCPA_COMMON" {
#  vpc_id = "${aws_vpc.VPC_COMMON.id}"
#  dhcp_options_id = "${aws_vpc_dhcp_options.DHCP_COMMON.id}"
#}
resource "aws_vpc_endpoint" "S3EP_COMMON_S3" {
  vpc_id          = "${aws_vpc.VPC_COMMON.id}"
  service_name    = "com.amazonaws.us-east-1.s3"
  route_table_ids = ["${aws_route_table.RT_COMMON_PRIVATE.id}","${aws_route_table.RT_COMMON_PUBLIC.id}"]
}
resource "aws_cloudwatch_log_group" "CLG_COMMON" {
  name = "prdshrd-log-group"
  retention_in_days = 7
}
resource "aws_flow_log" "FL_COMMON_FLOW" {
  log_group_name = "${aws_cloudwatch_log_group.CLG_COMMON.name}"
  iam_role_arn = "${aws_iam_role.IR_FLOW_LOGS.arn}"
  vpc_id = "${aws_vpc.VPC_COMMON.id}"
  traffic_type = "ALL"
}
