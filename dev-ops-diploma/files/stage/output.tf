output "internal_ip_address_proxy_yandex_cloud" {
  value = "${yandex_compute_instance.proxy.network_interface.0.ip_address}"
}

output "external_ip_address_proxy_yandex_cloud" {
  value = "${yandex_compute_instance.proxy.network_interface.0.nat_ip_address}"
}
output "internal_ip_address_db01_yandex_cloud" {
  value = "${yandex_compute_instance.db01.network_interface.0.ip_address}"
}
output "internal_ip_address_db02_yandex_cloud" {
  value = "${yandex_compute_instance.db02.network_interface.0.ip_address}"
}
output "internal_ip_address_wordpress_yandex_cloud" {
  value = "${yandex_compute_instance.wp.network_interface.0.ip_address}"
}
output "internal_ip_address_Gitlab_yandex_cloud" {
  value = "${yandex_compute_instance.git.network_interface.0.ip_address}"
}
output "internal_ip_address_monitoring_stack_yandex_cloud" {
  value = "${yandex_compute_instance.mon.network_interface.0.ip_address}"
}
