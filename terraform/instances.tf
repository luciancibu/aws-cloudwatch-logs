# Loki
resource "aws_instance" "amazon_linux_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instanceType
  key_name               = aws_key_pair.logsKeypair.key_name
  vpc_security_group_ids = [aws_security_group.amazon_linux_ec2_sg.id]
  availability_zone      = var.zone
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash
set -xe

yum update -y
amazon-linux-extras enable ansible2
yum install ansible -y

EOF

  tags = {
    Name    = "${var.projectName}"
    Project = var.projectName
    os = "amazonlinux"

  }
}

resource "aws_ec2_instance_state" "amazon_linux_ec2-state" {
  instance_id = aws_instance.amazon_linux_ec2.id
  state       = "running"
}