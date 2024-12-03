# Generate SSH Key Pair for EC2
resource "tls_private_key" "portfolio" {
    algorithm = "RSA"
      rsa_bits  = 2048
}

resource "aws_key_pair" "portfolio_keypair" {
    key_name   = "tfkey"
      public_key = tls_private_key.portfolio.public_key_openssh
}

# Save the private key locally
resource "local_file" "tf_key" {
    content  = tls_private_key.portfolio.private_key_pem
      filename = "tfkey.pem"
}

# Create Elastic IP for the instance (optional for public access)
resource "aws_eip" "portfolio_eip" {
    domain = "vpc"  # Specifies that this is for use in a VPC
}

# EC2 Instance Configuration
resource "aws_instance" "portfolio_instance" {
ami                         = "ami-066a7fbea5161f451"  # Replace with appropriate AMI ID
instance_type               = "t2.micro"
key_name                    = aws_key_pair.portfolio_keypair.key_name
vpc_security_group_ids      = [var.security_group_id]
subnet_id                   = var.subnet_id           # Use the passed subnet ID
associate_public_ip_address = true                           # Associates a public IP

# User data for EC2 instance configuration
user_data = file("${path.module}/userdata.sh")

tags = {
 Name = "portfolio-instance"
 }
}

# Associate Elastic IP with the instance (optional for dedicated IP)
resource "aws_eip_association" "portfolio_eip_association" {
    instance_id   = aws_instance.portfolio_instance.id
      allocation_id = aws_eip.portfolio_eip.id
}