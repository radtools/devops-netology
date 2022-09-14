resource "yandex_compute_instance" "db01" {
  name                      = "database-02"
  zone                      = var.zones[1]
  hostname                  = "db01.radtools.ru"
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
      ip_address  = "10.10.2.102"
      nat       = false

    }

    metadata = {
      ssh-keys = "ubuntu:${file("/.ssh/id_rsa.pub")}"
    }
    }

    resource "yandex_dns_recordset" "db01" {
      zone_id = yandex_dns_zone.zone1.id
      name    = "db01.radtools.ru."
      type    = "A"
      ttl     = 200
      data    = ["${yandex_compute_instance.db01.network_interface.0.ip_address}"]
    }