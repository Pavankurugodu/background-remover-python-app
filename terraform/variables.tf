variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name (optional)"
  type        = string
  default     = ""
}

variable "aws_assume_role_arn" {
  description = "Optional role ARN to assume"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment (dev/uat/prod)"
  type        = string
  default     = "dev"
}

variable "tfstate_bucket" {
  description = "S3 bucket for terraform state"
  type        = string
}

variable "tfstate_lock_table" {
  description = "DynamoDB table name for terraform state locks"
  type        = string
}
