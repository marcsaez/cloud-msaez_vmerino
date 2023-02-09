# EC2 hosting
resource "aws_instance" "hosting" {
    ami           = data.aws_ami.al2.id 
    instance_type = var.ec2_type
    key_name      = aws_key_pair.marc.key_name
    vpc_security_group_ids = [aws_security_group.hosting.id]
    associate_public_ip_address = true
    tags = {
      "Name" = "${var.name}hosting"
    }
    
}

# SSH PUBLIC KEY
resource "aws_key_pair" "marc" {
  key_name   = "marc-ssh_publickey"
  public_key = var.ssh_key
}

# SECURITY GROUP HOSTING
resource "aws_security_group" "hosting" {
  name = "${var.name}sg-hosting"
  egress {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = ""
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
