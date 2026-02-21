variable "aws_region" {
default = "us-east-1"
}
variable "ami_id" {
description = "Amazon Linux 2 AMI"
default = "ami-0f3caa1cf4417e51b"
}
variable "key_name" {
  description = "EC2 Key Pair Name"
    default     = "test"
}

