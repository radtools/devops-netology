resource "yandex_vpc_network" "t-net" {
  name        = "t-net -${terraform.workspace}"
  description = "Test net -${terraform.workspace}"

  labels = {
    environment = "${terraform.workspace}"
  }
}

resource "yandex_vpc_subnet" "subnet" {
  count = var.instance_count
  name           = "t-subnet - ${terraform.workspace}"
  description    = "Test Subnet - ${terraform.workspace}"
  zone           = var.zone
  network_id     = yandex_vpc_network.t-net.id
  v4_cidr_blocks = [var.subnet]
}
