# Genera clau pública y privada SSH
resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# Escriu la clau privada a on s'indica
resource "local_file" "ssh_private_key_pem" {
  filename = "keys/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

# Escriu la clau pública a on s'indica
resource "local_file" "ssh_public_key_openssh" {
  filename = "keys/id_rsa.pub"
  content = tls_private_key.global_key.public_key_openssh
}

# Copia la clau pública a AWS
resource "aws_key_pair" "rancher_key_pair" {
  key_name = "rancher-key"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Security group de Rancher
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "rancher_sg_msaez"
  description = "Rancher"

  ingress {
    from_port   = "22"
    to_port     = "22"
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
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }

  # ingress {
  #   from_port   = "6443"
  #   to_port     = "6443"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "3260"
  #   to_port     = "3260"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "30000"
  #   to_port     = "30000"
  #   protocol    = "udp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "30000"
  #   to_port     = "30000"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "8472"
  #   to_port     = "8472"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "2380"
  #   to_port     = "2380"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "9099"
  #   to_port     = "9099"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }



  # ingress {
  #   from_port   = "179"
  #   to_port     = "179"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "-1"
  #   to_port     = "-1"
  #   protocol    = "icmp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "2049"
  #   to_port     = "2049"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "30000"
  #   to_port     = "30000"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }



  # ingress {
  #   from_port   = "10250"
  #   to_port     = "10250"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "2379"
  #   to_port     = "2379"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "6443"
  #   to_port     = "6443"
  #   protocol    = "udp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "10254"
  #   to_port     = "10254"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = ""
  # }

  # ingress {
  #   from_port   = "8500"
  #   to_port     = "8500"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Vault"
  # }

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

# Crea la EC2 a AWS
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
      user = var.username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name = "rancher-server"
  }
}