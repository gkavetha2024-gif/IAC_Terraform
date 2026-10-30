# variable "ami" {
#   default = "ami-0b6d9d3d33ba97d99"
# }

# variable "instance_type" {
#   default = "t3.micro"
# }

# variable "key_name" {
#   default = "kav_aws_dev"
# }

# variable "subnet_id" {
#   default = "subnet-05ad029c56d36e319"
# }

# variable "iam_instance_profile" {
#   default = "kavdevinstprofile"
# }

# variable "vpc_security_group_ids" {
#   default = ["sg-00f2aa0a04a8c5df0"]
# }

variable "cidr_block" {
  default = "192.168.0.0/16"
  #  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}