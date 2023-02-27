# WEB 1
resource "null_resource" "file1" {
  triggers = {
    instance_id = aws_instance.hosting.id
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${aws_instance.hosting.public_ip}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source = "./webs/index.html"
    destination = "/home/ubuntu/index1.html"
  } 
  provisioner "remote-exec" {
    inline = [
      "cat ~/index1.html",
      "sleep 10",
      "until sudo mv ~/index1.html /var/www/web1/index.html"
    ]
  }
  depends_on = [
    aws_instance.hosting,
    data.template_file.cloud-init-config
  ]
}

resource "null_resource" "web2s" {
  triggers = {
    instance_id = aws_instance.hosting.id
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${aws_instance.hosting.public_ip}"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source = "./webs/DevBlog-Theme-master"
    destination = "/home/ubuntu/"
  } 
  provisioner "remote-exec" {
    inline = [
      "ls -l ~/DevBlog-Theme-master",
      "sleep 10",
      "until sudo cp -r ~/DevBlog-Theme-master/* /var/www/web2/"
    ]
  }
  depends_on = [
    aws_instance.hosting,
    data.template_file.cloud-init-config
  ]
}