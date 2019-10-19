resource "aws_vpc" "edx_build_aws_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "edx-build-aws-vpc"
  }
}

resource "aws_internet_gateway" "edx_igw" {
  vpc_id = aws_vpc.edx_build_aws_vpc.id

  tags = {
    Name = "edx-igw"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.edx_build_aws_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "edx-subnet-public-a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.edx_build_aws_vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "edx-subnet-public-b"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.edx_build_aws_vpc.id

  tags = {
    Name = "edx-routetable-public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.edx_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.edx_build_aws_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "edx-subnet-private-a"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.edx_build_aws_vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "edx-subnet-private-b"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_2.id
  depends_on    = ["aws_internet_gateway.edx_igw"]
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.edx_build_aws_vpc.id

  tags = {
    Name = "edx-routetable-private"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
