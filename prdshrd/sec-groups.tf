##########################################################################
# By creating a SG in a VPC, Terraform removes the default VPC SG thereby
# setting default to ALLOW NONE
# Default - None necessary
# Security Groups are stateful, are allow only (no deny rules)
##########################################################################
# SG_COMMON_PUBLIC
##########################################################################
resource "aws_security_group" "SG_COMMON_PUBLIC" {
    name            = "${var.environment}01 PUBLIC"
    vpc_id          = "${aws_vpc.VPC_COMMON.id}"
    tags {
      "Terraform"   = "true"
      "Name"        = "${var.environment}01 Public Base"
      "Owner"       = "${var.generic_owner}"
    }
    /*ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }*/
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}","${var.cidr_devshrd}"]
    }
    egress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}","${var.cidr_devshrd}"]
    }
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}","${var.cidr_devshrd}"]
    }
    egress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}","${var.cidr_devshrd}"]
    }
    ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}"]
    }
    egress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}"]
    }
}

##########################################################################
# SG_COMMON_PRIVATE
##########################################################################
resource "aws_security_group" "SG_COMMON_PRIVATE" {
    name            = "${var.environment}01 Private"
    vpc_id          = "${aws_vpc.VPC_COMMON.id}"
    tags {
      "Terraform"   = "true"
      "Name"        = "${var.environment}01 Private Base"
      "Owner"       = "${var.generic_owner}"
    }
    /*ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }*/
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}","${var.cidr_devshrd}"]
    }
    egress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}","${var.cidr_devshrd}"]
    }
    ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}"]
    }
    egress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["${var.cidr_vpn_110}","${var.cidr_vpn_111}","${var.cidr_vpn_112}","${var.cidr_vpn_Virtusa}"]
    }
}
