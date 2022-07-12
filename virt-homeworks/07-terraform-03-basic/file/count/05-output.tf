output "internal_ip_address_srv" {
  value = yandex_compute_instance.vmstudy-07-03[0].network_interface.0.ip_address
}

output "external_ip_address_srv" {
  value = yandex_compute_instance.vmstudy-07-03[0].network_interface.0.nat_ip_address
}
