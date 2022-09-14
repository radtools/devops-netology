resource "yandex_compute_instance" "db02" {
  name                      = "database-01"
  zone                      = var.zones[1]
  hostname                  = "db02.radtools.ru"
  platform_id               = "standard-v2"
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
      subnet_id = "${yandex_vpc_subnet.default[1].id}"
      ip_address  = "10.10.2.103"
      nat       = false

    }

    metadata = {
      ssh-keys = "ubuntu:${file("/.ssh/id_rsa.pub")}"
    }
    }

    resource "yandex_dns_recordset" "db02" {
      zone_id = yandex_dns_zone.zone1.id
      name    = "db02.radtools.ru."
      type    = "A"
      ttl     = 200
      data    = ["${yandex_compute_instance.db02.network_interface.0.ip_address}"]
    }