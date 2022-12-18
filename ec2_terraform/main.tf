provider "aws" {
  region = var.region
}
#------------------------------------------------------------------------------
# Terraform settings
#------------------------------------------------------------------------------
terraform {
  required_providers {
    aws = "<= 3.53.0"
  }

  backend "s3" {
    bucket         = "tfbackend-my-web-app-bucket"
    key            = "my-web-app.tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "tflockstate-my-web-app-table"
  }
}


module "ec2" {
source             = "./modules/ec2"
aws_region          = "us-east-1"
ami                 = "ami-03c1fac8dd915ff60"
instance_type       = "t2.micro"
security_group      = "agile-analog-sg"
PATH_TO_PRIVATE_KEY = "mykey"
PATH_TO_PUBLIC_KEY  = "mykey.pub"
INSTANCE_USERNAME   = "ec2-user"
instance_name       = "my-web-app"
username            = ["mac", "tom", "emma"]

}

