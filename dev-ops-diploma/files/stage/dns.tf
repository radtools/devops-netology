resource "yandex_dns_zone" "zone1" {
  name        = "radtools-public-zone"
  description = "My public zone"

  labels = {
    label1 = "radtools-public"
  }

  zone    = "radtools.ru."
  public  = true
}

