data "terraform_remote_state" "main" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}

# WEB 1
resource "null_resource" "web1" {
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
    source = "./webs/DevBlog-Theme-master"
    destination = "/home/ubuntu/"
    
  } 
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