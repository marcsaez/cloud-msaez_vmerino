# Busca l'imatge de Ubuntu Server 22.04 (Latest)
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

# Llegeix el cloud-init.yaml 
data "template_file" "cloud-init-config" {
  template = file("./config/cloud-init.yaml")
  vars = {
    ssh_msaez   = var.ssh_key_msaez
  }
}