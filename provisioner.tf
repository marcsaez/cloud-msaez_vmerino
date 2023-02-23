# WEB 1
resource "null_resource" "web1" {
  triggers = {
    instance_id = aws_instance.hosting.id
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${aws_instance.hosting.public_ip}"
    private_key = "${file("/home/austria/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source = "./webs/index.html"
    destination = "/home/ubuntu/index1.html"
  } 
  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/index1.html /var/www/web1/index.html"
    ]
  }
  depends_on = [
    aws_instance.hosting,
    data.template_file.cloud-init-config
  ]
}

resource "null_resource" "web2" {
  triggers = {
    instance_id = aws_instance.hosting.id
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${aws_instance.hosting.public_ip}"
    private_key = "${file("/home/austria/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source = "./webs/DevBlog-Theme-master"
    destination = "/home/ubuntu/."
  } 
  provisioner "remote-exec" {
    inline = [
      "sudo cp -r /home/ubuntu/DevBlog-Theme-master/* /var/www/web2/."
    ]
  }
  depends_on = [
    aws_instance.hosting,
    data.template_file.cloud-init-config
  ]
}