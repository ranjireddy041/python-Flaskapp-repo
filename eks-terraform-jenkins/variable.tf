variable "aws_region" {
default = "ap-south-1"
}
variable "ami_id" {
description = "Amazon Linux 2 AMI"
default = "ami-019715e0d74f695be"
}
variable "key_name" {
  description = "EC2 Key Pair Name"
    default     = "ap-test"
}

