variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The The Aws region where this resource wuill be deployed "
}

variable "region_code" {
  description = "Region code"
  default = {
    us-east-1 = "use1"
    us-west-1 = "usw1"
  }
}
#
variable "env" {
  type        = string
  default     = "poc"
  description = "The Environment where this resource wuill be deployed "
}

variable "deployer_role" {
  type        = string
  default     = "poc"
  description = "The role will be used resource deployment"
}



variable "aws_environment" {
  type = map(string)
  default = {
    dev  = "DEVELOPMENT"
    qa   = "QUALITY ASSURANCE"
    ppe  = "PRE-PRODUCTION"
    prod = "PRODUCTION"
  }
}


variable "private_subnet_az" {
  description = "Map for private subnets"
  default     = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    
  }
}
variable "publis_subnet_az" {
  description = "Map for private subnets"
  default     = {
    "us-east-1c" = 1
    "us-east-1d" = 2
  }
}