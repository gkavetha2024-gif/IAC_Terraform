# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Providers
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


# Resources
resource "aws_instance" "dev" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = ["sg-019e17329a841c87d"]
  iam_instance_profile   = var.iam_instance_profile
  user_data              = file("C:/DevOps_Pro_IAC_VM/IAC_Terraform/web.sh")

  #   user_data = <<-EOF
  # #!/bin/bash
  # sudo root
  # sudo hostnamectl set-hostname Terraform-Server.MYPC.COM
  # echo "`hostname -I | awk '{print $1}'` `hostname`" >> /etc/hosts
  # sudo apt update
  # sudo apt install nginx -y
  # sudo apt install unzip
  # timedatectl set-timezone "Asia/Kolkata"
  # mkdir /root/d1
  # cd /root/d1
  # sudo git pull https://github.com/Babugowli/HMStaticWP.git
  # sudo cp -r * /var/www/html
  # cd /var/www/html
  # cp index.html index.nginx-debian.html
  # rm -rf index.html

  #   EOF
  tags = {
    Name        = "AWS_Dev_Server"
    Environment = "Dev"
    ProjectName = "AWS DevOps 2026"
    ProjectID   = "2026"
    CreatedBy   = "iac Terraform"
  }
}


# Outputs
output "ami" {
  value = aws_instance.dev.ami
}
output "public_ip" {
  value = aws_instance.dev.public_ip
}
output "private_ip" {
  value = aws_instance.dev.private_ip
}