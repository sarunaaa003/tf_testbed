resource "aws_subnet" "SN_COMMON_PRIVATE" {
  vpc_id            = "${aws_vpc.VPC_COMMON.id}"
  count             = "${length(compact(split(",", var.region_azs)))}"
  availability_zone = "${element(split(",", var.region_azs), count.index)}"
  cidr_block        = "${element(split(",", var.cidr_block_private), count.index)}"
  tags {
    "Terraform" = "true"
    "Name"      = "${var.environment}01 Private ${count.index+1}"
    "Owner"     = "${var.generic_owner}"
  }
}

resource "aws_route_table" "RT_COMMON_PRIVATE" {
  vpc_id        = "${aws_vpc.VPC_COMMON.id}"
  tags {
    "Terraform" = "true"
    "Name"      = "${var.environment}01 Private"
    "Owner"     = "${var.generic_owner}"
  }
}

resource "aws_route_table_association" "RTA_COMMON_PRIVATE" {
  count          = "${length(compact(split(",", var.region_azs)))}"
  subnet_id      = "${element(aws_subnet.SN_COMMON_PRIVATE.*.id, count.index)}"
  route_table_id = "${aws_route_table.RT_COMMON_PRIVATE.id}"
}
