data "aws_route53_zone" "selected" {
  name = var.dns_name
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = "${aws_elb.app.dns_name}"
    zone_id                = "${aws_elb.app.zone_id}"
    evaluate_target_health = true
  }
}