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

resource "rustack_vm" "k3s_vm" {
  count  = 3
  vdc_id = resource.rustack_vdc.k3s.id
  name   = "k3s-${count.index}"
  cpu    = 2
  ram    = 2

  template_id = data.rustack_template.k3s_ubuntu20.id

  user_data = file("cloud-config.yaml")

  system_disk {
    size               = 30
    storage_profile_id = data.rustack_storage_profile.k3s_ssd.id
  }

  networks {
    id = resource.rustack_port.k3s_port[count.index].id
  }

  floating = true
}

output "k3s_vm_ip" {
  value = resource.rustack_vm.k3s_vm[*].floating_ip
}
