variable "aws_region" {
  description = "The region where AWS resources to be added"
}

variable "ami" {
  description = "name of AMI to be used"

}

variable "instance_type" {
  description = "Type of EC2 instance to be used"
}

variable "instance_name" {
  description = "Type of EC2 instance to be used"
}

variable "security_group" {
  description = "Name of the Security group to be used"
}
variable "hostname" {
  description = "servername prefix"
  default = "my-web-app"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "Name of my private key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "name of my public key"
}

variable "INSTANCE_USERNAME" {
  default = "Name of AWS EC2 instance user"
}

variable "username" {
  type = list(any)
}