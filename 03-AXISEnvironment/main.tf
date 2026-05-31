variable "ami" {
}

variable "key_name" {
}

variable "instance_type" {
}

resource "aws_instance" "kumar" {
  ami           = var.ami
  instance_type = var.instance_type

  key_name = var.key_name

  security_groups = ["sg-0addcfab477a4ae40"]

  subnet_id = "subnet-005e3389421ad11dc"

  vpc_security_group_ids = ["sg-0addcfab477a4ae40"]

  tags = {
    Name = "LinuxVM"
  }
}
