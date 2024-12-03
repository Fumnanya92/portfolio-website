# Security Group Configuration for portfolio and RDS instances
resource "aws_security_group" "portfolio_sg" {
  name_prefix = "portfolio-sg"
  description = "Security group for portfolio and RDS instances"
  vpc_id      = module.vpc.vpc_id

  # HTTP (80) - Allow for web access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (443) - Allow for secure web access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # SSH (22) - Allow access dynamically from EC2 instance IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Reference EC2 public IP
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# VPC Module Configuration
module "vpc" {
  source = "./modules/vpc"

  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

# EC2 Module Configuration
module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.public_subnet_1_id # Use public subnet 1 for EC2
  vpc_id            = module.vpc.vpc_id
  security_group_id = aws_security_group.portfolio_sg.id # Passing SG to module
  public_subnets    = module.vpc.public_subnet_ids       # Pass subnets here
}