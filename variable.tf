variable "aws_region" {
  description = "AWS region used for the S3 origin bucket."
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Globally unique name for the private S3 origin bucket."
  type        = string
  default     = "ohioze-devops-static-site"

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be between 3 and 63 characters."
  }
}
