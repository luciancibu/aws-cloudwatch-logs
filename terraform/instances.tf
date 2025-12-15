# Loki
resource "aws_instance" "amazon_linux_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instanceType
  key_name               = aws_key_pair.monitoringKeypair.key_name
  vpc_security_group_ids = [aws_security_group.amazon_linux_ec2_sg.id]
  availability_zone      = var.zone
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash
set -xe

yum update -y
yum install zip unzip wget httpd -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
wget https://www.tooplate.com/zip-templates/2152_event_invitation.zip
unzip 2152_event_invitation.zip
cp -r 2152_event_invitation/* /var/www/html/
systemctl restart httpd
EOF

  tags = {
    Name    = "${var.projectName}"
    Project = var.projectName
  }
}

resource "aws_ec2_instance_state" "amazon_linux_ec2-state" {
  instance_id = aws_instance.amazon_linux_ec2.id
  state       = "running"
}