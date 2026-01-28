data "aws_vpc" "default" {
  default = "true"
}
resource "aws_security_group" "app-sg" {
  name = "app-sg"
  description = "Security group for flask app"
  vpc_id = data.aws_vpc.default.id
    dynamic "ingress" {
      for_each = [22, 80, 443, 8080, 9000]
      content {
        from_port   = ingress.value
        to_port     = ingress.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
   
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
}

resource "aws_instance" "flaskapp" {
  ami = var.ami_id
  instance_type = "m7i-flex.large"
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  key_name = var.key_name
  tags = {
    Name = "flaskapp"
  }

connection {
    type        = "ssh"
    user        = "ubuntu"  
    private_key = file("C:/Users/ADMIN/Desktop/Terraform/terraform-eks-2/ap-test.pem")
    host        = self.public_ip  
}
  provisioner "remote-exec" {
              inline = [
                "set -e",
                "sudo apt-get update -y",
                "sudo apt-get install -y unzip curl",
                #✅ Optional: AWS CLI install
                "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"",
                "unzip -q awscliv2.zip",
                "sudo ./aws/install",
                "aws --version",
                #✅ Install kubectl
                "curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
                "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
                "kubectl version --client",
                #✅ Install eksctl
                "curl --silent --location \"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz\" | tar xz -C /tmp",
                "sudo mv /tmp/eksctl /usr/local/bin",
                "eksctl version"
              ]
            }     
} 
terraform {
  backend "s3" {
    bucket = "ranjith-devops-terraform-bucket-001"
    key    = "eks-flaskapp/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = "true"
  }
}

resource "aws_instance" "jenkins" {
  ami = var.ami_id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  key_name = var.key_name
  tags = {
    Name = "jenkins"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/ADMIN/Desktop/Terraform/terraform-eks-2/ap-test.pem")
    host = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install fontconfig openjdk-21-jre -y",
      "java -version",
      "sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key",
      "echo \"deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt update",
      "sudo apt install jenkins -y",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]
  }
}