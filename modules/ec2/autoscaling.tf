# Launch Template for portfolio Instances
resource "aws_launch_template" "portfolio_launch_template" {
  name_prefix   = "portfolio-launch-template"
  image_id      = "ami-066a7fbea5161f451"  # Replace with your AMI ID
  instance_type = "t2.micro"

  key_name = aws_key_pair.portfolio_keypair.key_name  # Assuming the key pair is available in the root module

  network_interfaces {
    security_groups = [var.security_group_id]  # Security group ID passed from the main module
    associate_public_ip_address = true         # Associates a public IP for the instances
  }

 user_data = base64encode(file("${path.module}/userdata.sh"))


  tags = {
    Name = "portfolio-instance"
  }
}

# Auto Scaling Group for portfolio Instances
resource "aws_autoscaling_group" "portfolio_asg" {
  desired_capacity        = 2                 # Adjust based on requirements
  max_size                = 3                 # Maximum number of instances
  min_size                = 1                 # Minimum number of instances

  launch_template {
    id      = aws_launch_template.portfolio_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier     = var.public_subnets  # List of public subnets from VPC

  target_group_arns       = [var.portfolio_tg_arn]  # Target group ARN from ALB module
  health_check_type       = "ELB"                    # Use load balancer for health checks
  health_check_grace_period = 300                    # Grace period for instance health check

  tag {
    key                   = "Name"
    value                 = "portfolio-instance"
    propagate_at_launch   = true
  }
}