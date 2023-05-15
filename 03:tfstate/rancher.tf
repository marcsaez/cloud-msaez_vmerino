resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename = "keys/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "keys/id_rsa.pub"
  content = tls_private_key.global_key.public_key_openssh
}

# SSH Key pair
resource "aws_key_pair" "rancher_key_pair" {
  key_name_prefix = "test-rancher-"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Security group 
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "rancher_sg"
  description = "Rancher"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "rancher_sg"
  }
  depends_on = [aws_key_pair.rancher_key_pair]
}


resource "aws_instance" "rancher" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = aws_key_pair.rancher_key_pair.key_name
  subnet_id = "subnet-00f67cae2874a3204"
  security_groups = [aws_security_group.rancher_sg_allowall.id]
  user_data_base64 = base64encode(data.template_file.cloud-init-config.rendered)
  ebs_optimized = true
  iam_instance_profile = "LabInstanceProfile"
  root_block_device {
    volume_type = "gp2"
    volume_size = 16
    encrypted = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
      "echo 'Rancher Server ready!'",
    ]
    connection {
      type = "ssh"
      host = self.public_ip
      user = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name = "rancher-server"
  }
}