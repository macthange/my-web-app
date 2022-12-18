locals {

  name    = "my-project"
  owner   = "my-Project@example.com"
  enabled = "true"
  prefix  = local.name

  region_code = lookup(var.region_code, var.region)
  common_tags = {
    prefix           = local.name
    resource-owner   = local.owner
    environment-type = var.aws_environment

  }

  kms_key = "${local.prefix}-kms-key-${var.env}-${local.region_code}"

aws_region          = "us-east-1"
ami                 = "ami-08e637cea2f053dfa"
instance_type       = "t2.micro"
security_group      = "agile-analog-sg"
PATH_TO_PRIVATE_KEY = "mykey"
PATH_TO_PUBLIC_KEY  = "mykey.pub"
INSTANCE_USERNAME   = "ec2-user"
username            = ["mac", "tom", "emma"]


}