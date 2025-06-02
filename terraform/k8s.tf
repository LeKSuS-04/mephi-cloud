variable "k3s_token" {
  type      = string
  sensitive = true
}

resource "rustack_vdc" "k3s" {
  name          = "K3s"
  project_id    = data.rustack_project.project.id
  hypervisor_id = data.rustack_hypervisor.kvm.id
}

data "rustack_network" "k3s_network" {
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "Сеть"
}

data "rustack_storage_profile" "k3s_ssd" {
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "ssd"
}

data "rustack_template" "k3s_ubuntu20" {
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "Ubuntu 20.04"
}

data "rustack_firewall_template" "k3s_allow_ingress" {
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "Разрешить входящие"
}

data "rustack_firewall_template" "k3s_allow_egress" {
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "Разрешить исходящие"
}

resource "rustack_port" "k3s_port" {
  count      = 3
  vdc_id     = resource.rustack_vdc.k3s.id
  network_id = data.rustack_network.k3s_network.id
  ip_address = "10.0.1.2${count.index}"
  firewall_templates = [
    data.rustack_firewall_template.k3s_allow_ingress.id,
    data.rustack_firewall_template.k3s_allow_egress.id,
  ]
}

resource "rustack_vm" "k3s_master" {
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "k3s-master"
  cpu    = 4
  ram    = 4

  template_id = data.rustack_template.k3s_ubuntu20.id

  user_data = templatefile("cloud-init/k3s-master.yaml", {
    k3s_token = var.k3s_token
  })

  system_disk {
    size               = 50
    storage_profile_id = data.rustack_storage_profile.k3s_ssd.id
  }

  networks {
    id = resource.rustack_port.k3s_port[0].id
  }

  floating = true
}

resource "rustack_vm" "k3s_agent" {
  count  = 2
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "k3s-agent-${count.index + 1}"
  cpu    = 2
  ram    = 2

  template_id = data.rustack_template.k3s_ubuntu20.id

  user_data = templatefile("cloud-init/k3s-agent.yaml", {
    k3s_token     = var.k3s_token
    k3s_master_ip = resource.rustack_vm.k3s_master.floating_ip
  })

  system_disk {
    size               = 50
    storage_profile_id = data.rustack_storage_profile.k3s_ssd.id
  }

  networks {
    id = resource.rustack_port.k3s_port[count.index + 1].id
  }

  floating = false
}

output "k3s_master_ip" {
  value = resource.rustack_vm.k3s_master.floating_ip
}
