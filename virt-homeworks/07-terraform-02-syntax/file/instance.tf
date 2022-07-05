resource "yandex_compute_instance" "vm-Ubuntu-srv" {
  name                      = "vm-centos-7"
  description               = "First test instance"
  allow_stopping_for_update = true

  resources {
    cores         = 1    #Количество ядер, доступных виртуальной машине.
    memory        = 512М #Объем памяти, доступный виртуальной машине.
    core_fraction = 5    #(опционально) Базовый уровень производительности vCPU.
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      # Ubuntu 20.04
      image_id    = "fd81u2vhv3mc49l1ccbb" #ID образа из маркетплейса ЯО
      name        = "disk-root"            #Имя диска  
      description = "Disk for the root"    #Описание диска
      size        = "${var.instance_root_disk}" #размер указан в переменных
    }
  }

  secondary_disk {
    disk_id     = "${yandex_compute_disk.disk-srv.id}"
    auto_delete = true
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.test-subnet.id}"
    nat       = true
  }

  metadata {
    ssh-keys = "extor:${file("~/.ssh/id_rsa.pub")}"
  }

  labels {
    environment = "test"
  }
}

resource "yandex_compute_disk" "disk-srv" {
  name = "disk-srv"
  type = "network-hdd"
  size = "${var.instance_additional_disk}" #размер указан в переменных

  labels {
    environment = "test"
  }
}
