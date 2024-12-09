variable "bucket_name" {
  description = "The base name for the S3 bucket. Must be globally unique."
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket (deletes all objects)."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks for bucket access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "check_existing_bucket" {
  description = "Whether to check for an existing bucket with the same name."
  type        = bool
  default     = true
}
