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

# Create VPC
resource "aws_vpc" "kavdev_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name        = "kavdev_vpc"
    Environment = "Dev"
    ProjectName = "AWS DevOps 2026"
    ProjectID   = "2026"
    CreatedBy   = "IAC_Terraform"
  }
}

# 6 Subnet  -  2Public & 4 Private Subnets

#Public Subnet 

resource "aws_subnet" "kavdev_public_subnet1" {
  vpc_id                  = aws_vpc.kavdev_vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name       = "kavdev_public_subnet1"
    created_by = "IAC_Terraform"
  }
}
resource "aws_subnet" "kavdev_public_subnet2" {
  vpc_id                  = aws_vpc.kavdev_vpc.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name       = "kavdev_public_subnet2"
    created_by = "IAC_Terraform"
  }
}

# Private Subnet

resource "aws_subnet" "kavdev_private_subnet01" {
  vpc_id            = aws_vpc.kavdev_vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name       = "kavdev_private_subnet01"
    created_by = "IAC_Terraform"
  }
}
resource "aws_subnet" "kavdev_private_subnet02" {
  vpc_id            = aws_vpc.kavdev_vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name       = "kavdev_private_subnet02"
    created_by = "IAC_Terraform"
  }
}
# resource "aws_subnet" "kavdev_private_subnet03" {
#   vpc_id            = aws_vpc.kavdev_vpc.id
#   cidr_block        = "10.0.6.0/28"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name       = "kavdev_private_subnet03"
#     created_by = "IAC_Terraform"
#   }
# }
# resource "aws_subnet" "kavdev_private_subnet04" {
#   vpc_id            = aws_vpc.kavdev_vpc.id
#   cidr_block        = "10.0.7.0/28"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name       = "kavdev_private_subnet04"
#     created_by = "IAC_Terraform"
#   }
# }


# RTB - Public-1
resource "aws_route_table" "kavdev_public_rtb" {
  vpc_id = aws_vpc.kavdev_vpc.id

  tags = {
    Name      = "kavdev_public_rtb"
    CreatedBy = "IAC-Terraform"
  }
}

# RTB - Private-1
resource "aws_route_table" "kavdev_private_rtb" {
  vpc_id = aws_vpc.kavdev_vpc.id

  tags = {
    Name      = "kavdev_private_rtb"
    CreatedBy = "IAC-Terraform"
  }
}

# IGW 
resource "aws_internet_gateway" "kavdev_igw" {
  vpc_id = aws_vpc.kavdev_vpc.id

  tags = {
    Name      = "kavdev_igw"
    CreatedBy = "IAC-Terraform"
  }

}

# Create Routing to Public-RTB From IGW
resource "aws_route" "kavdev_rtb_igw" {
  route_table_id         = aws_route_table.kavdev_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kavdev_igw.id

}


# Subnet Association with Public Route Table
resource "aws_route_table_association" "kavdev_public_subnet_1_association" {
  subnet_id      = aws_subnet.kavdev_public_subnet1.id
  route_table_id = aws_route_table.kavdev_public_rtb.id
}
# Subnet Association with Public Route Table
resource "aws_route_table_association" "kavdev_public_subnet_2_association" {
  subnet_id      = aws_subnet.kavdev_public_subnet2.id
  route_table_id = aws_route_table.kavdev_public_rtb.id
}

# Subnet Association with Private Route Table
resource "aws_route_table_association" "kavdev_private_subnet_1_association" {
  subnet_id      = aws_subnet.kavdev_private_subnet01.id
  route_table_id = aws_route_table.kavdev_private_rtb.id
}
# Subnet Association with Private Route Table
resource "aws_route_table_association" "kavdev_private_subnet_2_association" {
  subnet_id      = aws_subnet.kavdev_private_subnet02.id
  route_table_id = aws_route_table.kavdev_private_rtb.id
}

# # EIP  = other way to create EIP
# resource "aws_eip" "staragile_eip" {
#   vpc = true
# }

# Create Elastic IP (EIP)
resource "aws_eip" "kavdev_eip" {
  domain = "vpc"

  tags = {
    Name = "kavdev-eip"
  }
}

# NAT Gateway & Attach EIP to NAT GATEWAY
resource "aws_nat_gateway" "kavdev_natgw" {
  allocation_id = aws_eip.kavdev_eip.id
  subnet_id     = aws_subnet.kavdev_public_subnet1.id

  tags = {
    Name      = "kavdev_natgw"
    CreatedBy = "IAC-Terraform"
  }
}

# Allow  Nat Gateway To Private Route Table
resource "aws_route" "kavdev_allow_natgw" {
  route_table_id         = aws_route_table.kavdev_private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.kavdev_natgw.id

}

# NACL 
resource "aws_network_acl" "kavdev_nacl" {
  vpc_id = aws_vpc.kavdev_vpc.id
  subnet_ids = [aws_subnet.kavdev_public_subnet1.id,
    aws_subnet.kavdev_public_subnet2.id,
    aws_subnet.kavdev_private_subnet01.id,
    aws_subnet.kavdev_private_subnet02.id]

  # ingress / inbound
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  # egress / outbound
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name      = "kavdev_nacl"
    CreatedBy = "IAC - Terraform"
  }

}

# SG For Bastion - Windows Server (Public Server)
resource "aws_security_group" "windows_sg" {
  vpc_id      = aws_vpc.kavdev_vpc.id
  name        = "windows_server"
  description = "Allow SSH And RDP"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "windows_server"
    Description = "Allow SSH and RDP"
    CreatedBy   = "IAC - Terraform"
  }

}

# SG For WebServer - Ubuntu Server (Private Server)
resource "aws_security_group" "ubuntu_sg_web" {
  vpc_id      = aws_vpc.kavdev_vpc.id
  name        = "ubuntu_sg"
  description = "Allow SSH - RDP - HTTP - DB "

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  // MySQL DB Port
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ubuntu_web"
    Description = "Allow SSH - RDP - HTTP - DB"
    CreatedBy   = "IAC - Terraform"
  }

}

// Create Windows Server Instance - Public IP Enabled - Public Subnet
resource "aws_instance" "Windows_Server" {
  ami                    = "ami-0b16ced290e00a1a3"
  instance_type          = "t3.micro"
  key_name               = "kav_aws_dev"
  subnet_id              = aws_subnet.kavdev_public_subnet1.id
  vpc_security_group_ids = ["${aws_security_group.windows_sg.id}"]
  iam_instance_profile   = "kavdevinstprofile"
  user_data              = file("C:/DevOps_Pro_IAC_VM/IAC_Terraform/web.sh")

  tags = {
    Name      = "Windows_Server"
    CreatedBy = "IAC - Terraform"
    OSType    = "Windows"
  }
}

// Create Ubuntu Server Instance - Public IP Disabled - Private Subnet
resource "aws_instance" "Ubuntu_Server" {
  ami                    = "ami-0d97d7f07b25dd693"
  instance_type          = "t3.micro"
  key_name               = "kav_aws_dev"
  subnet_id              = aws_subnet.kavdev_private_subnet01.id
  vpc_security_group_ids = ["${aws_security_group.ubuntu_sg_web.id}"]
  user_data              = file("C:/DevOps_Pro_IAC_VM/IAC_Terraform/userdata.sh")

  tags = {
    Name      = "Ubuntu_Server"
    CreatedBy = "IAC - Terraform"
    OSType    = "Linux - Ubuntu 20.04"
  }
}