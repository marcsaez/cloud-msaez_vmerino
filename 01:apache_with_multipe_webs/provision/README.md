# Template file for add a new web in the web server
````hcl
resource "null_resource" "<< UNIQUE NAME FOR RESOURCE >>" {
  triggers = {
    instance_id = data.terraform_remote_state.main.outputs.ip_ec2
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = "${data.terraform_remote_state.main.outputs.ip_ec2}"
    private_key = "${file("<< PATH TO PRIVATE SSH KEY >>")}"
  }
  provisioner "file" {
    source = "<< PATH TO LOCAL FILE or REPO WITH THE WEB >>"
    destination = "~/."
  } 
  provisioner "remote-exec" {
    inline = [
      "",
      "sudo cp ~/<< PATH TO EC2 FILE or REPO with the WEB >> /var/www/web1/index.html"
    ]
  }
}
