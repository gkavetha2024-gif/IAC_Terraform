variable "ami" {
  default = "ami-0b6d9d3d33ba97d99"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "kav_aws_dev"
}

variable "subnet_id" {
  default = "subnet-05ad029c56d36e319"
}

variable "iam_instance_profile" {
  default = "kavdevinstprofile"
}