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
  key_name   = var.key_name
  public_key = file(var.key_path)
}
