locals {
  instance_name = "${terraform.workspace}-instance[0]"
}



resource "yandex_compute_instance" "vmstudy-07-03"{
  count = var.instance_count
  name = local.instance_name
  description = "discpiption - ${terraform.workspace}" 
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  resources {
    cores         = var.cores
    memory        = var.mem
    core_fraction = var.fraction
  }


  boot_disk {
    auto_delete = true

    initialize_params {
      # Ubuntu 20.04
      image_id    = var.image-id                                    #переменная ID образа из маркетплейса ЯО
      name        = "disk-${terraform.workspace}"                   #Имя диска  
      description = "Disk for the root - ${terraform.workspace}"    #Описание диска
      size        = var.instance_root_disk                          #размер указан в переменных
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.disk-srv[0].id
    auto_delete = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet[0].id
    nat       = true
    }
}
resource "yandex_compute_disk" "disk-srv" {
  count = var.instance_count
  name = "disk-srv-[0]${terraform.workspace}"
  type = "network-hdd"
  size = var.instance_additional_disk                                 #размер указан в переменных
}