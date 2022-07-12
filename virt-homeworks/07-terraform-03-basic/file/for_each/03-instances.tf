locals {
  id = toset(var.id)
}



resource "yandex_compute_instance" "vmstudy-07-03"{
  for_each                  = local.id
  name                      = "vm-${each.key}-${terraform.workspace}"
  description               = "discpiption - ${terraform.workspace}" 
  allow_stopping_for_update = true
  platform_id               = var.instance_type
  resources {
    cores                   = var.cores
    memory                  = var.mem
    core_fraction           = var.fraction
  }


  boot_disk {
    auto_delete = true

    initialize_params {
      # Ubuntu 20.04
      image_id    = var.image-id                                    #переменная ID образа из маркетплейса ЯО
      name        = "vm${each.key}-disk-${terraform.workspace}"                   #Имя диска  
      description = "Disk for the root - ${terraform.workspace}"    #Описание диска
      size        = var.instance_root_disk                          #размер указан в переменных
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
    }
}