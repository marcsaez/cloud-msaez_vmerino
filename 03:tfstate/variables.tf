# VARS
variable "instance_type" { default = "t3a.medium" }
variable "docker_version" {default = "19.03"}
locals {
  node_username = "ubuntu"
}
variable "node_username" {}