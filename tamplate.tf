data "template_file" "script" {
  template = "${file("${path.module}/scripts/upgrade.sh")}"
  vars = {
    databases_ip   = aws_db_instance.default.endpoint
    elb_endpoint   = aws_elb.app.dns_name
    redis_endpoint = aws_elasticache_cluster.default.cache_nodes.0.address
    db_name        = var.db_name
    db_user_name   = var.db_user_name
    db_pass        = var.db_pass
  }
}
