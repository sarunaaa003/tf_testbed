# Peer Routing
# https://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/peering-configurations-partial-access.html
# Need Route for public and private 0.0.0.0/0 to squid proxy group in devcmsvs\public

############################################################################
# Egress
############################################################################
# Internet for vpc default

# Internet for subnet route tables
resource "aws_route" "RT_COMMON_PUBLIC_TO_EXTERNAL" {
  route_table_id = "${aws_route_table.RT_COMMON_PUBLIC.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.IGW_COMMON.id}"
}
resource "aws_route" "RT_COMMON_PRIVATE_TO_EXTERNAL" {
  route_table_id = "${aws_route_table.RT_COMMON_PRIVATE.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NGW_COMMON_PUBLIC.id}"
}
