variable "aws_private_endpoints" {
  type = map
  default = {
    ec2 = "",
    sts = ""
  }
}

variable "aws_region" {
  description = "AWS region to deploy to. Must match the private endpoints."
  default     = "us-west-1"
}

variable "instance_ami" {
  description = "AMI to create test instance from. Must match the region."
  default     = "ami-0f56279347d2fa43e"
}

provider "aws" {
  region = var.aws_region

  endpoints {
    ec2 = var.aws_private_endpoints.ec2
    sts = var.aws_private_endpoints.sts
  }
}

resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
