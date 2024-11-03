# provider

provider "aws" {
  region = var.aws_region
}

#varibles.tf
variable "aws_region" {
description = "aws_region"
type        = string
default     = "us-east-1"
}
         
variable "vpc_cidr" {
description = "CIDR block for vpc"
type        = string
default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "ami_id" {
description = "ami ID for the EC2 Instance"
type        = string
default     = "ami-01e3c4a339a264cc9"
}

variable "instance_type" {
description = "Instance Type for the EC2 Instance"
type        = string
default        = "t2.micro"
}

variable "db_username" {
description = "Database username"
type        = string
default     = "admin"
}

variable "db_password" {
description = "Database password"
type        = string
sensitive   = true
}

#vpc.tf
# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "two-tier-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[0]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}
 
# Private Subnet in us-east-1a
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = "us-east-1a"
}
 
# New Private Subnet in us-east-1b
resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"  # Different CIDR block
  availability_zone = "us-east-1b"
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"                 # Route for all IPs
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# DB Subnet Group for RDS, using both private subnets
resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_az2.id]

  tags = {
    Name = "Main subnet group"
  }
}

#security_groups.tf
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
 tags = {
  Name = "Web Security Group"
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
 tags = {
  Name = "Database Security group"
  }
}

#ec2.tf
#web server instance
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  # Use security group ID
  
  tags = {
    Name = "Web Server"
  }
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  # Use security group ID
  
  tags = {
    Name = "Application Server"
  }
}


#database.tf
resource "aws_db_instance" "db_instance" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  identifier             = "skywalkn-db"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.id
  skip_final_snapshot    = true
}

#outputs.tf
# output for Public IP of the Web Server
output "web_server_public_ip" {
description = "Public IP address for the web server"
value       = aws_instance.web_server.public_ip
}

# output for the Private IP of the Appliaction Server
output "app_server_private_ip" {
description = "Private IP address for the app server"
value       = aws_instance.app_server.private_ip
}

#output for Database Endpoint
output "database_endpoint" {
description = "Endpoint for the RDS database"
value       = aws_db_instance.db_instance.endpoint
}

#output for VPC id
output "vpc_id" {
description = "ID of the VPC"
value       = aws_vpc.main_vpc.id
}

