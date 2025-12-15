
# Deployment script for Ansible
resource "local_file" "ansible_deployment" {
  filename = "../${var.deployName}"

  content = templatefile("${path.module}/templates/deploy.tmpl", {
    ansible_ip       = aws_instance.amazon_linux_ec2.public_ip
    ansible_user     = var.ansibleUserByOS[aws_instance.amazon_linux_ec2.tags.os]
    clientkey        = "${aws_key_pair.logsKeypair.key_name}.pem"
  })
}