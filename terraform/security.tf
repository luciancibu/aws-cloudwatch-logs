# Loki Security Group
resource "aws_security_group" "amazon_linux_ec2_sg" {
  name = "${var.projectName}-sg"
  description = "Security group for amazon_linux_ec2_sg"

  ingress {
    description = "SSH from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myIP}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.projectName}-sg"
    Project = var.projectName
  }
}