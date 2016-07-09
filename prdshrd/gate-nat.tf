# Gateways and NAT
resource "aws_internet_gateway" "IGW_COMMON" {
  vpc_id               = "${aws_vpc.VPC_COMMON.id}"
  tags {
    "Terraform"        = "true"
    "Name"             = "${var.environment}01"
    "Owner"            = "${var.generic_owner}"
  }
}

# NAT TODO: remove for squid proxy groups
resource "aws_eip" "EIP_COMMON_PUBLIC_NAT" {
  vpc   = true
}

resource "aws_nat_gateway" "NGW_COMMON_PUBLIC" {
  allocation_id = "${aws_eip.EIP_COMMON_PUBLIC_NAT.id}"
  subnet_id     = "${aws_subnet.SN_COMMON_PUBLIC.1.id}"
  depends_on    = ["aws_internet_gateway.IGW_COMMON"]
}
