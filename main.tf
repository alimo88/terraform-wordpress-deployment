data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "public" {
  id = data.aws_subnets.default.ids[0]
}

module "ec2" {
  source = "./modules/ec2"

  ami_id        = "ami-0a0ff88d0f3f85a14"
  subnet_id     = data.aws_subnet.public.id
  instance_type = var.instance_type
  key_name      = var.key_name
  ssh_cidr      = var.ssh_cidr
}


