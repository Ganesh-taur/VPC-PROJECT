output "wordpress_public_ip" {
  value = aws_instance.wordpress.public_ip
  description = "The public IP address of the WordPress instance"
}

output "mysql_private_ip" {
  value = aws_instance.mysql.private_ip
  description = "The private IP address of the MySQL instance"
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
  description = "VPC ID"
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
  description = "Public subnet ID"
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
  description = "Private subnet ID"
}