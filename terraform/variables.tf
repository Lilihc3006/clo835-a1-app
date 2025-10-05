variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the demo host"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Optional: EC2 key pair name for SSH access. Leave null to rely on Session Manager."
  type        = string
  default     = null
}
