variable "domain_name" {
  description = "The domain name for the hosted zone."
  type        = string
}

#variable "alb_dns_name" {
 # description = "The DNS name of the ALB."
 # type        = string
#}

#variable "alb_zone_id" {
 # description = "The zone ID of the ALB."
 # type        = string
#}

variable "sub_record" {
  description = "The subdomain or record to create in Route 53."
  type        = string
  default     = "www"
}

variable "s3_website_endpoint" {
  description = "The S3 bucket website endpoint."
  type        = string
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}
