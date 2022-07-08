resource "yandex_compute_instance" "vm-1" {
  name = "debian11"
  #description               = var.desc-instance
  #allow_stopping_for_update = true
  platform_id = "standard-v2"
  resources {
    cores         = 2 #Количество ядер, доступных виртуальной машине.
    memory        = 1 #Объем памяти, доступный виртуальной машине.
    core_fraction = 5 #(опционально) Базовый уровень производительности vCPU.
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      # Ubuntu 20.04
      image_id    = var.image-id           #переменная ID образа из маркетплейса ЯО
      name        = "disk-root"            #Имя диска  
      description = "Disk for the root"    #Описание диска
      size        = var.instance_root_disk #размер указан в переменных
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.disk-srv.id
    auto_delete = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.test-subnet.id
    nat       = true
  }

  #labels = {
  #  environment = "test"
  #}
}

resource "yandex_compute_disk" "disk-srv" {
  name = "disk-srv"
  type = "network-hdd"
  size = var.instance_additional_disk #размер указан в переменных
}





locals {
  instance_name = "${terraform.workspace}-instance"
}