resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
    count                   = 3
    name                    = "subnet-${var.zones[count.index]}"
    zone                    = var.zones[count.index]
    network_id              = "${yandex_vpc_network.default.id}"
    v4_cidr_blocks          = [var.cidr[count.index]]
    route_table_id          = yandex_vpc_route_table.route-table-nat.id
  }

resource "yandex_vpc_route_table" "route-table-nat" {
    name        = "route-table-nat"

    network_id = "${yandex_vpc_network.default.id}"

    static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address = "10.10.1.10"
    }
  }