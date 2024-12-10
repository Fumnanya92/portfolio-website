variable "aws_region" {
  type = string
}

variable "default_vpc" {
  type = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Forcefully destroy the bucket (deletes all objects)"
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks for bucket access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
