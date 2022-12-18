resource "aws_iam_group" "newemp_group" {
  name = "newemp-group"
}

resource "aws_iam_user" "newemp" {
  count = length(var.username)
  name  = element(var.username, count.index)
}

resource "aws_iam_group_membership" "team" {
  name = "newemp-group-membership"

  users = [
    aws_iam_user.newemp.0.name,
    aws_iam_user.newemp.1.name,
    aws_iam_user.newemp.2.name,
  ]

  group = aws_iam_group.newemp_group.name
}

resource "aws_iam_group_policy_attachment" "dynamodb_attach" {
  group      = aws_iam_group.newemp_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}