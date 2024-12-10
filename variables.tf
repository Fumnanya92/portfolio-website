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
