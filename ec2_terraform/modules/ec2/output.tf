output "EC2_PUBLIC_IP" {
  value = aws_instance.my-web-app.public_ip
}


output "user_arn" {
  value = aws_iam_user.newemp.*.arn
}