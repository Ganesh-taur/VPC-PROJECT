variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone to launch resources in"
  default     = "us-east-1a"
}

 
variable "wordpress_ami" {
  description = "AMI ID for the WordPress EC2 instance"
  default     = "ami-0e2c8caa4b6378d8c"  # Example AMI
}

variable "mysql_ami" {
  description = "AMI ID for the MySQL EC2 instance"
  default     = "ami-0e2c8caa4b6378d8c"  # Example AMI
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}