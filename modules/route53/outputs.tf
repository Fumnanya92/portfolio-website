output "zone_id" {
  description = "ID of the Route 53 hosted zone"
  value       = aws_route53_zone.hosted_zone.zone_id
}
