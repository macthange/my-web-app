variable "ami_id" {
  type    = string
  default = "ami-01e78c5619c5e68b4"
}


variable "app_name" {
  type    = string
  default = "my-web-app"
}


locals {
    app_name = "httpd"
	timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}



source "amazon-ebs" "httpd" {
  ami_name      = "linux-${local.app_name}-${local.timestamp}"
  encrypt_boot  = "true"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn-ami-hvm-????.??.?.????????-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username  = "ec2-user"
  tags = {
    Env  = "dev"
    Name = "linux-${var.app_name}"
  }

}

build {
  sources = ["source.amazon-ebs.httpd"]

  provisioner "shell" {
    script = "script/script.sh"
  }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }
}