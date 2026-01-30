terraform {
  backend "s3" {
    bucket = "ranjith-devops-terraform-bucket-001" # Replace with your actual S3 bucket name
    key    = "eks-flaskapp/terraform.tfstate"
    region = "ap-south-1"
  }
}
