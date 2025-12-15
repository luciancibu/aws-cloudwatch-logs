# Documentation References:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair

resource "tls_private_key" "logsKey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "logsKeypair" {
  key_name   = "${var.projectName}-key"
  public_key = tls_private_key.logsKey.public_key_openssh
}

resource "local_file" "client_private_key" {
  filename = "${path.root}/${aws_key_pair.logsKeypair.key_name}.pem"
  content  = tls_private_key.logsKey.private_key_pem
  file_permission = "0400"
}

