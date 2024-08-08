
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name        = var.vpc_name
    Environment = var.ambiente
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "IGW-${var.ambiente}"
    Environment = var.ambiente
  }
}

resource "aws_subnet" "subnet-public-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.170.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "SNet-public-A"
    Environment = var.ambiente
  }
}

resource "aws_subnet" "subnet-public-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.170.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "SNet-public-B"
    Environment = var.ambiente
  }
}


resource "aws_subnet" "subnet-private-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.170.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "SNet-private-A"
    Environment = var.ambiente
  }
}

resource "aws_subnet" "subnet-private-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.170.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "SNet-private-B"
    Environment = var.ambiente
  }
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name        = "EIP-NAT-A"
    Environment = var.ambiente
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name        = "EIP-NAT-B"
    Environment = var.ambiente
  }
}



resource "aws_nat_gateway" "nat-a" {
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_a.id
  subnet_id         = aws_subnet.subnet-private-a.id

  tags = {
    Name = "NAT-GW-A"
  }
}

resource "aws_nat_gateway" "nat-b" {
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_b.id
  subnet_id         = aws_subnet.subnet-private-b.id

  tags = {
    Name = "NAT-GW-B"
  }
}

resource "aws_route_table" "rtb-nat-a" {
  vpc_id = aws_vpc.main.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-a.id
  }
  depends_on = [aws_nat_gateway.nat-a]
}

resource "aws_route_table" "rtb-nat-b" {
  vpc_id = aws_vpc.main.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-b.id
  }
  depends_on = [aws_nat_gateway.nat-b]
}

resource "aws_route_table_association" "associate-rtb-nat-a" {
  subnet_id      = aws_subnet.subnet-private-a.id
  route_table_id = aws_route_table.rtb-nat-a.id
}

resource "aws_route_table_association" "associate-rtb-nat-b" {
  subnet_id      = aws_subnet.subnet-private-b.id
  route_table_id = aws_route_table.rtb-nat-b.id
}


resource "aws_route_table" "rtb-public-a" {
  vpc_id = aws_vpc.main.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "rtb-public-b" {
  vpc_id = aws_vpc.main.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "associate-rtb-public-a" {
  subnet_id      = aws_subnet.subnet-public-a.id
  route_table_id = aws_route_table.rtb-public-a.id
}

resource "aws_route_table_association" "associate-rtb-public-b" {
  subnet_id      = aws_subnet.subnet-public-b.id
  route_table_id = aws_route_table.rtb-public-b.id
}