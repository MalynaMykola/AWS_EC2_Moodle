resource "aws_instance" "web" {
  depends_on                  = ["aws_db_instance.default", "aws_elasticache_cluster.default"]
  count                       = var.instance_count
  associate_public_ip_address = false
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = element(var.availability_zone, count.index)
  subnet_id                   = element(aws_subnet.private.*.id, count.index)
  security_groups             = [aws_security_group.allow_http.id]
  user_data                   = data.template_file.script.rendered

  tags = {
    Name = "Moodle-${count.index}"
  }
}