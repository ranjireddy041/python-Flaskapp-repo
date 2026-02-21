terraform {
  backend "s3" {
    bucket = "ranjith-devops-terraform-bucket-001-us" # Replace with your actual S3 bucket name
    key    = "todo-app/terraform.tfstate"
    region = "ua-east-1"
  }
}
