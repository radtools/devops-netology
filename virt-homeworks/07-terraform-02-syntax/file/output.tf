output "internal_ip_address_ubuntu" {
  value = "${yandex_compute_instance.vm-Ubuntu-srv.network_interface.0.ip_address}"
}

output "external_ip_address_centos7" {
  value = "${yandex_compute_instance.vm-Ubuntu-srv.network_interface.0.nat_ip_address}"
}
