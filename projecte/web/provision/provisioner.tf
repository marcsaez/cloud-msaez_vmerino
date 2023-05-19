# Llegeix el terraform.tfstate anterior per poder indicar-li recursos d'un altre módul
data "terraform_remote_state" "main" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

# WEB 1, aprovisiona el repositori local i el copia a la EC2 indicada
resource "null_resource" "web1" {
  # Instancia a la que apunta
  triggers = {
    instance_id = data.terraform_remote_state.main.outputs.ip_ec2
  }
  # Conexxió SSH
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${data.terraform_remote_state.main.outputs.ip_ec2}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  # Origen i destí del arxiu
  provisioner "file" {
    source = "./webs/DevBlog-Theme-master"
    destination = "/home/ubuntu/"
    
  } 
  # Comandes que executa a la instancia remota
  provisioner "remote-exec" {
    inline = [
      "ls -l ~/DevBlog-Theme-master",
      "sudo cp -r ~/DevBlog-Theme-master/* /var/www/web1/"
      
    ]
  }
}

resource "null_resource" "web2s" {
  triggers = {
    instance_id = data.terraform_remote_state.main.outputs.ip_ec2
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${data.terraform_remote_state.main.outputs.ip_ec2}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source = "./webs/index.html"
    destination = "/home/ubuntu/index1.html"
  } 
  provisioner "remote-exec" {
    inline = [
      "cat ~/index1.html",
      "sudo cp ~/index1.html /var/www/web2/index.html"
    ]
  }
  depends_on = [
    null_resource.web1
  ]
}