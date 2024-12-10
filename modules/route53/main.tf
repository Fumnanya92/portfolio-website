resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name

  tags = {
    Name = "Hosted Zone for ${var.domain_name}"
  }
}

resource "aws_route53_record" "cname_record" {
  zone_id = var.zone_id
  name    = var.sub_record
  type    = "CNAME"
  ttl     = 300
  records = [var.s3_website_endpoint]
}

