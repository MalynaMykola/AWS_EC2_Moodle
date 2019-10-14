resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.databases.*.id

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  availability_zone      = var.availability_zone[0]
  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.allow_rds.id]
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.db_type
  name                   = var.db_name
  username               = var.db_user_name
  password               = var.db_pass
  parameter_group_name   = "default.mysql5.7"
}
resource "aws_elasticache_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.databases.*.id
}

resource "aws_elasticache_cluster" "default" {
  cluster_id           = "redis"
  subnet_group_name    = aws_elasticache_subnet_group.default.id
  security_group_ids   = [aws_security_group.allow_redis.id]
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}
