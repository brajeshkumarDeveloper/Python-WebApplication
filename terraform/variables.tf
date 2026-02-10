variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
