locals {
  aws_region = "<insert AWS Region" #"us-west-1"
  aws_vpc_id = "<insert VPC ID>"

  # Update with AWS Service names
  services = [
    "ec2",
    "sts"
  ]
}

# Allow all traffic, in reality you would want to isolate CIDR's to your internal network.
resource "aws_security_group" "vpcendpoint" {
  name        = "VPCEndpointSG"
  description = "AWS Services on VPC Endpoint Security Group"
  vpc_id      = module.tfe1-networking.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "aws_services" {
  for_each = toset(local.services)

  vpc_id              = module.tfe1-networking.vpc_id
  service_name        = format("com.amazonaws.%s.%s", local.aws_region, each.value)
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.tfe1-networking.private_subnet_ids
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpcendpoint.id
  ]
}

output private_endpoints {
  value = [for end in aws_vpc_endpoint.aws_services : end.dns_entry[0].dns_name]

  # Example output:
  # private_endpoints = [
  #   "vpce-xxxxxxxxxxxxxxxxx-zzzzzzzz.ec2.us-west-1.vpce.amazonaws.com",
  #   "vpce-xxxxxxxxxxxxxxxxx-zzzzzzzz.sts.us-west-1.vpce.amazonaws.com",
  # ]
}
