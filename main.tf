resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "wordpress-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "private-subnet"
  }
}

 resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow HTTP traffic for WordPress"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "wp_mysql_key" {
  key_name   = "wp_mysql_key"
  public_key = file(var.ssh_public_key_path)  # SSH key path as a variable
}

resource "aws_instance" "wordpress" {
  ami           = var.wordpress_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.wp_mysql_key.key_name
  security_groups = [aws_security_group.wordpress_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              amazon-linux-extras enable php7.4
              yum install -y php php-mysqlnd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "WordPress Instance"
  }
}

 
resource "aws_instance" "mysql" {
  ami           = var.mysql_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = aws_key_pair.wp_mysql_key.key_name
  security_groups = [aws_security_group.mysql_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mysql-server
              systemctl start mysqld
              systemctl enable mysqld
              EOF

  tags = {
    Name = "MySQL Instance"
  }
}