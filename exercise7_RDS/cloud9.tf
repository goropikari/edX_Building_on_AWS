resource "aws_cloud9_environment_ec2" "example" {
  instance_type               = "t2.micro"
  name                        = "BuildingOnAWS"
  subnet_id                   = aws_subnet.public_1.id
  automatic_stop_time_minutes = 30
}

output "cloud9_id" {
  value = aws_cloud9_environment_ec2.example.id
}

#
# Obtain the Cloud9 EC2 instance_id
#
data "aws_instances" "ec2s" {
  filter {
    name   = "tag:Name"
    values = ["*${aws_cloud9_environment_ec2.example.id}"]
  }

  instance_state_names = ["running", "stopped"]
}

output "cloud9_ec2_instance_id" {
  value = data.aws_instances.ec2s.ids[0]
}
