#переменные

variable "zone" {
  default = "ru-central1-b"
}

variable "yandex-token" {
  default = "<token>"
}

variable "yandex-cloud-id" {
  default = "<cloud-id>"
}

variable "yandex-folder-id" {
  default = "<folder-id>"
}

variable "instance_root_disk" {
  default = "20"
}

variable "instance_additional_disk" {
  default = "5"
}
