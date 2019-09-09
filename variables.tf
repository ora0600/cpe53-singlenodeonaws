# AWS Config

variable "aws_access_key" {
  default = "your key"
}

variable "aws_secret_key" {
  default = "your secret"
}

variable "aws_region" {
  default = "your region"
}

variable "vpc_securitygroup_id" {
  default = "your security group ID"
}

variable "vpc_subnet_id" {
  default = "your subnet ID"
}

variable "ssh_key_name" {
  default = "your ssh key"
}

variable "instance_type_resource" {
  default = "t2.large"
}

variable "instance_count" {
    default = "1"
  }

variable "confluent_platform_location" {
  default = "http://packages.confluent.io/archive/5.3/confluent-5.3.0-2.12.tar.gz"
}

variable "confluent_home_value" {
  default = "/home/ec2-user/software/confluent-5.3.0"
}
