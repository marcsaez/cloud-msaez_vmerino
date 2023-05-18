# Hosting
resource "aws_instance" "hosting" {
  ami           =  data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  tags = {
    "Name" = "msaez"
  } 
  vpc_security_group_ids = [aws_security_group.hosting.id]
  key_name = aws_key_pair.marc.key_name
}

# "ami-007855ac798b5175e"

# SSH PUBLIC KEY
resource "aws_key_pair" "marc" {
  key_name   = "marc-ssh_publickey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpJGWF4vUpSyZgsT6/uylFwecdaL4six8YOgy2PmPnJCmwwbI6jUuPy8LsWfc7paRsc976/8IxUGOxlxQ7EucMrz5NrfPhjUv6DDztEKNTFg2moSCdReNuBNqjmdSd1Z68uVmMFqSMfbLfds7c+Kib3UF/VreKDS5nKs6gjLlQhjwbWtBW8WAAX2c0kqr6UbiGhYPDF2eiGLjPa6donhYxdaFZwN0cIVMWY48WX51Ptd9qJTKvtE10ZOgkmKy3LZK56+V0IJ81UC/DWEmrS0nHU2lolY8vsYrDSftf+krpvhKbx76FulPV8ZGRyxbOaNU/OhifyjZ6WTpAOmdOyy9AgjTNvx8/UIdOQkKeaHMuxwRWT7FIECziM+TqCLChjrv+RpZvIPuLKLLoX/AS1FsZbd6zNN9sHfNTQMTRqfEjE+5OIlteK8VuMMM5t1QyZeusb8/Ouz0YDA5vMuxTUFxucwP7jm+FFcU4jZjgPsxz2WUPedqJgeUluuXmh/xpFFE= austria@austria-Lenovo-V14-ADA"
}


# SECURITY GROUP HOSTING
resource "aws_security_group" "hosting" {
  name = "msaezsg-hosting"
  egress {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = "Permitir salir a todo"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
 
  ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = "SSH connection"
      from_port        = 22
      protocol         = "tcp"
      security_groups  = []
      to_port          = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
   },
   {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = "HTTP connection"
      from_port        = 80
      protocol         = "tcp"
      security_groups  = []
      to_port          = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
   },
   {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = "HTTPs connection"
      from_port        = 443
      protocol         = "tcp"
      security_groups  = []
      to_port          = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
   }
   ]
}