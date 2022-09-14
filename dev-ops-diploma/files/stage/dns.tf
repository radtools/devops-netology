resource "yandex_dns_zone" "zone1" {
  name        = "radtools-public-zone"
  description = "My public zone"

  labels = {
    label1 = "radtools-public"
  }

  zone    = "radtools.ru."
  public  = true
}


resource "yandex_dns_recordset" "proxy" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "radtools.ru."
  type    = "A"
  ttl     = 200
  data    = [" ${yandex_compute_instance.proxy.network_interface.0.nat_ip_address} "]
}
