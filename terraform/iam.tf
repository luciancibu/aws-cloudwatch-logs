# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "${var.projectName}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# CloudWatch Logs full access
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_logs_full" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Allow EC2 (CloudWatch agent) to send metrics to CloudWatch
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_agent" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# For debug -> aws cloudwatch list-metrics --namespace CWAgent
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_readonly" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.projectName}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
