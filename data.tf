# Ubuntu Server 22.04 AMI (Latest)
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

# cloud-init.yaml
data "template_file" "cloud-init-config" {
  template = file("./config/cloud-init.yaml")
  vars = {
    public_ip=aws_instance.hosting.public_ip
  }
}