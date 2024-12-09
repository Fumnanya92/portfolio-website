output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}


output "portfolio_tg_arn" {
  description = "The ARN of the portfolio Target Group"
  value       = aws_lb_target_group.portfolio_tg.arn
}


output "alb_sg_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb_sg.id  # Ensure this is the correct resource name
}