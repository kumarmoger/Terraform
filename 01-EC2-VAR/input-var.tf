variable "ami" {
  description = "Amazon Machine Image"
  default     = "ami-0e12ffc2dd465f6e4"
}

variable "instance_type" {
  description = "EC2 Machine"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name"
  default     = "kumarl"
}