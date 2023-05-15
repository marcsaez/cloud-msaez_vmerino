# Versions
terraform {
  backend "s3" {
     bucket         = "terraform-state-msaez"
     key            = "global/s3/terraform.tfstate"
     region         = "us-east-1"
     profile        = "insti"
     dynamodb_table = "terraform-locks"
     encrypt        = true
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    k8s = {
      source  = "banzaicloud/k8s"
      version = "0.9.1"
    }
    local = {
      source  = "hashicorp/local"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.25.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.4.0"
    }
  }
  required_version = ">= 0.13"
}