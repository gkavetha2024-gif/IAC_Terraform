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

// Create Windows Server Instance - Public IP Enabled - Public Subnet
resource "aws_instance" "Ansible_Server" {
  ami                    = "ami-0d97d7f07b25dd693"
  instance_type          = "t3.micro"
  key_name               = "kav_aws_dev"
  subnet_id              = "subnet-05ad029c56d36e319"
  vpc_security_group_ids = ["sg-0a38c5009888b5f8d"]
  iam_instance_profile   = "kavdevinstprofile"
  user_data              = file("C:/DevOps_Pro_IAC_VM/IAC_Terraform/web.sh")

  tags = {
    Name        = "AnsibleController_Server"
    Environment = "Dev"
    ProjectName = "Kav-AWS"
    ProjectID   = "KAV-2026"
    CreatedBy   = "IAC - Terraform"
  }
}

// Create Ubuntu Server Instance - Public IP Disabled - Private Subnet
resource "aws_instance" "NodeWebController_Server" {
  ami                    = "ami-0d97d7f07b25dd693"
  instance_type          = "t3.micro"
  key_name               = "kav_aws_dev"
  subnet_id              = "subnet-05ad029c56d36e319"
  vpc_security_group_ids = ["sg-0a38c5009888b5f8d"]
  iam_instance_profile   = "kavdevinstprofile"
  user_data              = file("C:/DevOps_Pro_IAC_VM/IAC_Terraform/userdata.sh")

  tags = {
    Name        = "NodeWebController_Server"
    Environment = "Dev"
    ProjectName = "Kav-AWS"
    ProjectID   = "KAV-2026"
    CreatedBy   = "IAC - Terraform"
  }
}