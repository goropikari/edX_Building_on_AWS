provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "ami" {
  default = "ami-08d489468314a58df" # amazon linux Oregon us-west-2
}

resource "aws_key_pair" "default" {
  key_name   = "edx_build_aws"
  public_key = file("~/.ssh/edx_build_aws.pub")
}
