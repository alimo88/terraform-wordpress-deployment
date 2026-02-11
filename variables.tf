variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "ssh_cidr" {
  type        = string
  description = "Your public IP in CIDR format"

}
