# Create a VPC
resource "aws_vpc" "Ben" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Ben-vpc"
  }
}

# Create 2 Public subnets
resource "aws_subnet" "public_subnet-1" {
  vpc_id                  = aws_vpc.Ben.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" # Change the AZ as needed
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id                  = aws_vpc.Ben.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b" # Change the AZ as needed
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet-1" {
  vpc_id                  = aws_vpc.Ben.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c" # Change the AZ as needed
  tags = {
    Name = "private_subnet-1"
  }
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id                  = aws_vpc.Ben.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1d" # Change the AZ as needed
  tags = {
    Name = "private_subnet-2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Ben.id
  tags = {
    Name = "Ben-igw"
  }
}

# Create a route table
resource "aws_route_table" "public_rt-1" {
  vpc_id = aws_vpc.Ben.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table-1"
  }
}

resource "aws_route_table" "public_rt-2" {
  vpc_id = aws_vpc.Ben.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table-2"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_rt-1_assoc" {
  subnet_id      = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.public_rt-1.id
}
resource "aws_route_table_association" "public_rt-2_assoc" {
  subnet_id      = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.public_rt-2.id
}

# Create a NAT Gateway (optional, for private subnet internet access)
resource "aws_eip" "nat_eip-1" {
  vpc = true
}

resource "aws_eip" "nat_eip-2" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw-1" {
  allocation_id = aws_eip.nat_eip-1.id
  subnet_id     = aws_subnet.public_subnet-1.id
  tags = {
    Name = "Ben-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_gw-2" {
  allocation_id = aws_eip.nat_eip-2.id
  subnet_id     = aws_subnet.public_subnet-2.id
  tags = {
    Name = "Ben-nat-gw-2"
  }
}

# Create a private route table
resource "aws_route_table" "private_rt-1" {
  vpc_id = aws_vpc.Ben.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw-1.id
  }
  tags = {
    Name = "private-route-table-1"
  }
}

resource "aws_route_table" "private_rt-2" {
  vpc_id = aws_vpc.Ben.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw-2.id
  }
  tags = {
    Name = "private-route-table-2"
  }
}
#Private route table association
resource "aws_route_table_association" "private_rt-1_assoc" {
  subnet_id      = aws_subnet.private_subnet-1.id
  route_table_id = aws_route_table.private_rt-1.id
}
resource "aws_route_table_association" "private_rt-2_assoc" {
  subnet_id      = aws_subnet.private_subnet-2.id
  route_table_id = aws_route_table.private_rt-2.id
}