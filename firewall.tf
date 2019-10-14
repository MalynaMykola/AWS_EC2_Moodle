resource "aws_security_group" "allow_http" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "allow_rds"
  }
}
resource "aws_security_group" "allow_redis" {
  name        = "allow_redis"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  
  }
  tags = {
    Name = "allow_redis"
  }
}
