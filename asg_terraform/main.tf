provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      hashicorp-learn = "aws-asg"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnets       = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "Name of my private key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_launch_configuration" "mywebapp" {
  name_prefix     = "terraform-aws-asg-"
  image_id        = "ami-07b55f240ca96401b"
  instance_type   = "t2.micro"
   // Public SSH key
  key_name = aws_key_pair.mykey.key_name
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.mywebapp_instance.id]
   connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(mykey.pub)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "mywebapp" {
  name                 = "mywebapp"
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.mywebapp.name
  vpc_zone_identifier  = module.vpc.private_subnets

  tag {
    key                 = "Name"
    value               = "mywebapp"
    propagate_at_launch = true
  }
}

resource "aws_lb" "mywebapp" {
  name               = "asg-mywebapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mywebapp_lb.id]
  subnets            = module.vpc.public_subnets
}

/*
data "aws_acm_certificate" "cert" {
  domain   = "tf.example.com"
  types = ["AMAZON_ISSUED"] #IMPORTED
  most_recent = true
}


resource "aws_lb_listener" "mywebapp" {
  load_balancer_arn = aws_lb.mywebapp.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.cert.arn
  ssl_policy = "ELBSecurityPolicy-2016-08"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mywebapp.arn
  }
}
*/
resource "aws_lb_listener" "mywebapp" {
  load_balancer_arn = aws_lb.mywebapp.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mywebapp.arn
  }
}

resource "aws_lb_target_group" "mywebapp" {
  name     = "asg-mywebapp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}


resource "aws_autoscaling_attachment" "mywebapp" {
  autoscaling_group_name = aws_autoscaling_group.mywebapp.id
  alb_target_group_arn   = aws_lb_target_group.mywebapp.arn
}

resource "aws_security_group" "mywebapp_instance" {
  name = "asg-mywebapp-instance"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.mywebapp_lb.id]
  }
   ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.mywebapp_lb.id]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.mywebapp_lb.id]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "mywebapp_lb" {
  name = "asg-mywebapp-lb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}
