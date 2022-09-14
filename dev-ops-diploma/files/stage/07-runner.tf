resource "yandex_compute_instance" "runner" {
  name                      = "runner-vm"
  zone                      = var.zones[2]
  hostname                  = "runner.radtools.ru"
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
      subnet_id = "${yandex_vpc_subnet.default[2].id}"
      ip_address  = "10.10.3.107"
      nat       = false

    }

    metadata = {
      ssh-keys = "ubuntu:${file("/.ssh/id_rsa.pub")}"
    }
    }

    resource "yandex_dns_recordset" "runner" {
      zone_id = yandex_dns_zone.zone1.id
      name    = "runner.radtools.ru."
      type    = "A"
      ttl     = 200
      data    = ["${yandex_compute_instance.runner.network_interface.0.ip_address}"]
    }