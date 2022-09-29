resource "yandex_compute_instance" "mon" {
  name                      = "monitoring-vm"
  zone                      = var.zones[2]
  hostname                  = "monitoring.radtools.ru"
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
      ip_address  = "10.10.3.106"
      nat       = false

    }

    metadata = {
      ssh-keys = "ubuntu:${file(".ssh/id_rsa.pub")}"
    }
    }

    resource "yandex_dns_recordset" "monitoring" {
      zone_id = yandex_dns_zone.zone1.id
      name    = "monitoring.radtools.ru."
      type    = "A"
      ttl     = 200
      data    = ["${yandex_compute_instance.mon.network_interface.0.ip_address}"]
    }

    resource "yandex_dns_recordset" "rs5" {   
      zone_id = yandex_dns_zone.zone1.id   
      name    = "grafana.radtools.ru."     
      type    = "A"                        
      ttl     = 200                        
      data    = [" ${yandex_compute_instance.proxy.network_interface.0.nat_ip_address} "]
    }
    resource "yandex_dns_recordset" "rs6" {   
      zone_id = yandex_dns_zone.zone1.id   
      name    = "prometheus.radtools.ru."  
      type    = "A"                        
      ttl     = 200                        
      data    = [" ${yandex_compute_instance.proxy.network_interface.0.nat_ip_address} "]
    }
    resource "yandex_dns_recordset" "rs7" {   
      zone_id = yandex_dns_zone.zone1.id   
      name    = "alertmanager.radtools.ru."
      type    = "A"                        
      ttl     = 200                        
      data    = [" ${yandex_compute_instance.proxy.network_interface.0.nat_ip_address} "]
    }
