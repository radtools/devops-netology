resource "yandex_compute_instance" "proxy" {
  name                        = "nginx-proxy"
  platform_id                 = "standard-v2"
  zone                        = var.zones[0]
  hostname                    = "radtools.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }
  scheduling_policy {
    preemptible = true
  }

    boot_disk {
        initialize_params {
          image_id = data.yandex_compute_image.ubuntu_image.id
        }
      }

    network_interface {
      subnet_id = "${yandex_vpc_subnet.default[0].id}"
      ip_address  = "10.10.1.10"
      nat       = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file(".ssh/id_rsa.pub")}"
    }
    }
    
    resource "yandex_dns_recordset" "rs1" {
      zone_id = yandex_dns_zone.zone1.id
      name    = "radtools.ru."
      type    = "A"
      ttl     = 200
      data    = [" ${yandex_compute_instance.proxy.network_interface.0.nat_ip_address} "]
    }