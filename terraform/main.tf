terraform {
  required_version = ">= 1.0.0"

  required_providers {
    rustack = {
      source  = "terraform.rustack.ru/rustack-cloud-platform/rcp"
      version = "> 1.1.0"
    }
  }
}

variable "api_token" {
  type      = string
  sensitive = true
}

provider "rustack" {
  api_endpoint = "https://cloud.mephi.ru"
  token        = var.api_token
}

data "rustack_project" "project" {
  name = "kafka"
}

data "rustack_hypervisor" "kvm" {
  project_id = data.rustack_project.project.id
  name       = "РУСТЭК"
}
