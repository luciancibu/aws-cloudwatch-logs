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

data "aws_iam_policy_document" "ec2_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket" // allow to list (aws s3 ls) files from bucket e.g. aws s3 ls s3://logs-bucket
    ]
    resources = [
      aws_s3_bucket.logs_deploy.arn,   // for "s3:ListBucket"
      "${aws_s3_bucket.logs_deploy.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "ec2_cloudwatch_s3" {
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.ec2_s3_policy.json
}

# CloudWatch Logs full access
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_logs_full" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.projectName}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
