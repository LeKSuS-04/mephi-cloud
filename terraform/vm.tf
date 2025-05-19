resource "rustack_vdc" "kafka" {
  name          = "Kafka"
  project_id    = data.rustack_project.project.id
  hypervisor_id = data.rustack_hypervisor.kvm.id
}

data "rustack_network" "kafka_network" {
  vdc_id = resource.rustack_vdc.kafka.id
  name   = "Сеть"
}

data "rustack_storage_profile" "kafka_ssd" {
  vdc_id = resource.rustack_vdc.kafka.id
  name   = "ssd"
}

data "rustack_template" "kafka_ubuntu20" {
  vdc_id = resource.rustack_vdc.kafka.id
  name   = "Ubuntu 20.04"
}

data "rustack_firewall_template" "kafka_allow_ingress" {
  vdc_id = resource.rustack_vdc.kafka.id
  name   = "Разрешить входящие"
}

data "rustack_firewall_template" "kafka_allow_egress" {
  vdc_id = resource.rustack_vdc.kafka.id
  name   = "Разрешить исходящие"
}

resource "rustack_port" "kafka_port" {
  vdc_id     = resource.rustack_vdc.kafka.id
  network_id = data.rustack_network.kafka_network.id
  ip_address = "10.0.1.20"
  firewall_templates = [
    data.rustack_firewall_template.kafka_allow_ingress.id,
    data.rustack_firewall_template.kafka_allow_egress.id,
  ]
}

resource "rustack_vm" "kafka_vm" {
  vdc_id = resource.rustack_vdc.kafka.id
  name   = "kafka"
  cpu    = 2
  ram    = 2

  template_id = data.rustack_template.kafka_ubuntu20.id

  user_data = file("cloud-config.yaml")

  system_disk {
    size               = 30
    storage_profile_id = data.rustack_storage_profile.kafka_ssd.id
  }

  networks {
    id = resource.rustack_port.kafka_port.id
  }

  floating = true
}

output "kafka_vm_ip" {
  value = resource.rustack_vm.kafka_vm.floating_ip
}
