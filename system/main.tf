provider "aws" {
  region = "us-west-2"
}


resource "aws_instance" "exercise2" {
  ami                    = "ami-08d489468314a58df" # amazon linux Oregon us-west-2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.exercise2.id]

  user_data = file("./user_data.sh")

  tags = {
    Name = "SamplePythonFlaskApp"
  }
}

resource "aws_security_group" "exercise2" {
  name = "exercise2-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.exercise2.public_ip
}

output "public_dns" {
  value = aws_instance.exercise2.public_dns
}
