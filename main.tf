terraform {
  backend "s3" {
    bucket         = "portfolioweb-terraform-state" # Replace with your bucket name
    key            = "terraform/terraform.tfstate"  # Replace with a custom path
    region         = "us-west-2"                    # Replace with your bucket region
    dynamodb_table = "Portfolioweb-terraform-state" # Replace with your DynamoDB table name
    encrypt        = true                           # Enable encryption for added security
  }
}

# Security Group Configuration for portfolio 
resource "aws_security_group" "portfolio_sg" {
  name_prefix = "portfolio-sg"
  description = "Security group for portfolio "
  vpc_id      = var.default_vpc

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



# S3 Module Configuration
module "s3" {
  source                = "./modules/s3"
  bucket_name           = var.bucket_name
  versioning_enabled    = var.versioning_enabled
  force_destroy         = var.force_destroy
  allowed_cidr_blocks   = var.allowed_cidr_blocks
  check_existing_bucket = true
}

# Upload Portfolio Script to S3
resource "aws_s3_object" "portfolio_script" {
  bucket       = module.s3.bucket_name
  key          = "index.html" # Specify the key in the bucket
  source       = "${path.module}/index.html"
  content_type = "text/html" # Static type for index.html
}

resource "aws_s3_object" "portfolio_image" {
  bucket       = module.s3.bucket_name
  key          = "portfolio_img.png" # Specify the key in the bucket
  source       = "${path.module}/portfolio_img.png"
  content_type = "image/png" # Static type for portfolio_img.png
}



module "route53" {
  source              = "./modules/route53"
  domain_name         = "workfoliowave.xyz"
  zone_id             = module.route53.zone_id            # Pass zone_id from the module
  s3_website_endpoint = module.s3.bucket_website_endpoint # Pass website endpoint from the S3 module
}


