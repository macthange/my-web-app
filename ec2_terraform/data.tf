/*
data "aws_ami" "golden_image" {
  owners      = ["060139604389"]
  most_recent = true
  filter {
    name   = "name"
    values = ["refinitiv-amzn2-hvm-*"]
  }
}
*/



#data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpc" "default" {
  default = true
} 

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_availability_zones" "available" {
  state = "available"
}