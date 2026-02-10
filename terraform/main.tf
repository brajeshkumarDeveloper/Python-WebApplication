# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "6.30.0"
#     }

#      random = {
#       source = "hashicorp/random"
#       version = "3.8.1"
#     }
#   }
# }

# provider "aws" {
#     region = "us-east-1"
# }

# resource "random_id" "rand_id" {
#   byte_length = 8
  
# }

# resource "aws_s3_bucket" "mywebapp-bucket" {
#   bucket = "mywebapp-bucket-${random_id.rand_id.hex}"
  
# }

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.mywebapp-bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_policy" "mywebapp" {
#   bucket = aws_s3_bucket.mywebapp-bucket.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:GetObject"
#         Resource  = "arn:aws:s3:::${aws_s3_bucket.mywebapp-bucket.id}/*"
#       }
#     ]
#   })

#     depends_on = [ 
#        aws_s3_bucket.mywebapp-bucket,
#        aws_s3_bucket_public_access_block.example
#      ]
# }

# resource "aws_s3_bucket_website_configuration" "mywebapp" {
#   bucket = aws_s3_bucket.mywebapp-bucket.id

#   index_document {
#     suffix = "index.html"
#   }

# }

# resource "aws_s3_object" "index_html" {
#   bucket       = aws_s3_bucket.mywebapp-bucket.bucket
#   key          = "index.html"
#   source       = "index.html"
#   content_type = "text/html"
# }

# resource "aws_s3_object" "styles_css" {
#   bucket       = aws_s3_bucket.mywebapp-bucket.bucket
#   key          = "styles.css"
#   source       = "styles.css"
#   content_type = "text/css"
# }



# output "name" {
#   value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
  
# }
# ==================================================



# Security Group
resource "aws_security_group" "fastapi_sg" {
  name        = "fastapi-sg"
  description = "Allow SSH, HTTP, FastAPI ports"
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "FastAPI port"
    from_port   = 8000
    to_port     = 8000
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

# EC2 instance
resource "aws_instance" "fastapi_ec2" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = var.instance_type
  security_groups = [aws_security_group.fastapi_sg.name]

  tags = {
    Name = "FastAPI-App-Server"
  }
}

# Output public IP
output "ec2_public_ip" {
  value = aws_instance.fastapi_ec2.public_ip
}
