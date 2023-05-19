# Cloid-Init Configuration
# ----------------------------------------------------------
# Llegeix el cloud-init.yaml
data "template_file" "cloud-init-config" {
  template = file("./config/cloud-init.yaml")
  vars = {
    docker_version = var.docker_version
    username       = var.username
  }
}




# Busca la imatge AMI més actual d'Ubuntu Server 18.04 a AWS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}