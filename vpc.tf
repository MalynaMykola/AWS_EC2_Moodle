resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  count                   = var.vpc_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = var.vpc_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1${count.index + 1}.0/24"
  availability_zone = element(var.availability_zone, count.index)


  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "databases" {
  count             = var.vpc_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2${count.index + 1}.0/24"
  availability_zone = element(var.availability_zone, count.index)


  tags = {
    Name = "databases-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "main-nat"
  }
}


resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-public"
  }
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-natgw.id
  }

  tags = {
    Name = "main-private"
  }
}
resource "aws_route_table_association" "public" {
  count          = var.vpc_count
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "private" {
  count          = var.vpc_count
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = aws_route_table.main-private.id
}
