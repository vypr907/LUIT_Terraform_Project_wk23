#modules/network/main

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "avail_zone_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

#create our VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "wk23_vpc_${random_integer.random.id}"
    Project = "Week_23"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#subnets
resource "aws_subnet" "public_subnet" {
  count                   = var.pub_sub_ct
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.avail_zone_list.result[count.index]

  tags = {
    Name    = "wk23_pub_sub_${count.index + 1}"
    Project = "Week_23"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = var.priv_sub_ct
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.avail_zone_list.result[count.index]

  tags = {
    Name    = "wk23_priv_sub_${count.index + 2}"
    Project = "Week_23"
  }
}

resource "aws_route_table_association" "pub_assoc" {
  count          = var.pub_sub_ct
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.pub_rt.id
}

#routing
#PUBLIC
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "wk23_pub_rt"
    Project = "Week_23"
  }
}

resource "aws_route" "default_pub_route" {
  route_table_id         = aws_route_table.pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_gateway.id
}

#PRIVATE
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "wk23_priv_rt"
    Project = "Week_23"
  }
}

resource "aws_route" "default_priv_route" {
  route_table_id         = aws_route_table.priv_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgate.id
}

resource "aws_default_route_table" "def_priv_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name    = "wk23_def_priv_rt"
    Project = "Week_23"
  }
}


#gateways
resource "aws_internet_gateway" "web_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "wk23_igw"
    Project = "Week_23"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "natgate" {
  allocation_id = aws_eip.wk23_eip.id
  subnet_id     = aws_subnet.public_subnet[1].id
}

#eip
resource "aws_eip" "wk23_eip" {

}

#security groups
#PUBLIC
resource "aws_security_group" "pub_sg" {
  name        = "wk23_bastion_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#PRIVATE
resource "aws_security_group" "priv_sg" {
  name        = "wk23_server_sg"
  description = "Allow SSH inbound traffic from Bastion Host"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.pub_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#WEB
resource "aws_security_group" "web_sg" {
  name        = "wk23_web_sg"
  description = "Allow all inbound HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

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