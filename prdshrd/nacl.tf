##########################################################################
# We set this to deny all as we will specify rules on a per subnet basis.
# NACL only manages egress, Ingress is managed by Security Groups
# Flush default vpc nacl - DENY ALL BY OMMITTING
# www.terraform.io/docs/providers/aws/r/default_network_acl.html
##########################################################################
# NACL_COMMON (Default)
##########################################################################
resource "aws_default_network_acl" "NACL_COMMON" {
  default_network_acl_id = "${aws_vpc.VPC_COMMON.default_network_acl_id}"
  ingress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  /*egress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }*/
}

#resource "aws_default_network_acl" "NACL_STAGING" {
#  default_network_acl_id = "${aws_vpc.VPC_STAGING.default_network_acl_id}"
#  ingress {
#    rule_no = 99
#    protocol = "all"
#    action = "allow"
#    cidr_block =  "0.0.0.0/0"
#    from_port = 0
#    to_port = 0
#  }
  /*egress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }*/
#}
#resource "aws_default_network_acl" "NACL_PRDCTON" {
#  default_network_acl_id = "${aws_vpc.VPC_PRDCTON.default_network_acl_id}"
#  ingress {
#    rule_no = 99
#    protocol = "all"
#    action = "allow"
#    cidr_block =  "0.0.0.0/0"
#    from_port = 0
#    to_port = 0
#  }
  /*egress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }*/
#}

##########################################################################
# NACL_COMMON_PRIVATE
##########################################################################
resource "aws_network_acl" "NACL_COMMON_PRIVATE" {
  vpc_id = "${aws_vpc.VPC_COMMON.id}"
  subnet_ids = ["${aws_subnet.SN_COMMON_PRIVATE.*.id}"]
  tags {
      Terraform = "true"
      Name = "${var.environment} Private"
  }
  /*ingress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }*/
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_INGRESS" {
  network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
  rule_number = 99
  egress = false
  protocol = "all"
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  from_port = 0
  to_port = 0
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_EGRESS_443" {
  network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
  count = "${length(compact(split(",", var.region_azs)))}"
  rule_number = "${count.index + 10}"
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block =  "${element(aws_subnet.SN_COMMON_PUBLIC.*.cidr_block, count.index)}"
  from_port = 443
  to_port = 443
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_443_VPN" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 15
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "10.110.0.0/15"
    from_port = 443
    to_port = 443
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_443_VPN_2" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 16
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_112}"
    from_port = 443
    to_port = 443
}
/*resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_SSH_STAGEPRD" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 4
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "10.200.0.0/15"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_SSH_PRDSHRD" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 5
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_prdshrd}"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_SSH_VPN" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 6
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "10.110.0.0/15"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_SSH_VPN_2" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 7
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_112}"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_SSH_VIRTUSA" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 8
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_Virtusa}"
    from_port = 22
    to_port = 22
}*/
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_TO_SHARED_COMMON" {
  network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
  rule_number = 9
  egress = true
  protocol = "all"
  rule_action = "allow"
  cidr_block =  "${var.cidr_devshrd}"
  from_port = 0
  to_port = 0
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_EPHEMERAL" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 99
    egress = true
    protocol = "all"
    rule_action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
}
##########################################################################
# NACL_COMMON_PUBLIC
##########################################################################
resource "aws_network_acl" "NACL_COMMON_PUBLIC" {
  vpc_id = "${aws_vpc.VPC_COMMON.id}"
  subnet_ids = ["${aws_subnet.SN_COMMON_PUBLIC.*.id}"]
  tags {
      Terraform = "true"
      Name = "${var.environment} Public"
  }
  /*ingress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
  egress {
    rule_no = 99
    protocol = "all"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }*/
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_INGRESS" {
  network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
  rule_number = 99
  egress = false
  protocol = "all"
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  from_port = 0
  to_port = 0
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_EGRESS_443" {
  network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
  rule_number = 10
  egress = true
  protocol = "tcp"
  rule_action = "allow"
  cidr_block =  "0.0.0.0/0"
  from_port = 443
  to_port = 443
}
/*resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_SSH_STAGEPRD" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 4
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "10.200.0.0/15"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_SSH_PRDSHRD" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 5
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_prdshrd}"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_SSH_VPN" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 6
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "10.110.0.0/15"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_SSH_VPN_2" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 7
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_112}"
    from_port = 22
    to_port = 22
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_SSH_VIRTUSA" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 8
    egress = true
    protocol = "tcp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_Virtusa}"
    from_port = 22
    to_port = 22
}*/
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_TO_SHARED_COMMON" {
  network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
  rule_number = 9
  egress = true
  protocol = "all"
  rule_action = "allow"
  cidr_block =  "${var.cidr_devshrd}"
  from_port = 0
  to_port = 0
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_EPHEMERAL" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 99
    egress = true
    protocol = "all"
    rule_action = "allow"
    cidr_block =  "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
}


##################################################
# ICMP Temporary

/*resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_1_VPN" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 30
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block =  "10.110.0.0/15"
    from_port = 1
    to_port = 1
    icmp_type = -1
    icmp_code = -1
}
resource "aws_network_acl_rule" "NACL_COMMON_PRIVATE_1_VPN_2" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PRIVATE.id}"
    rule_number = 31
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_112}"
    from_port = 1
    to_port = 1
    icmp_type = -1
    icmp_code = -1
}

resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_1_VPN" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 32
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block =  "10.110.0.0/15"
    from_port = 1
    to_port = 1
    icmp_type = -1
    icmp_code = -1
}
resource "aws_network_acl_rule" "NACL_COMMON_PUBLIC_1_VPN_2" {
    network_acl_id = "${aws_network_acl.NACL_COMMON_PUBLIC.id}"
    rule_number = 33
    egress = true
    protocol = "icmp"
    rule_action = "allow"
    cidr_block =  "${var.cidr_vpn_112}"
    from_port = 1
    to_port = 1
    icmp_type = -1
    icmp_code = -1
}*/
