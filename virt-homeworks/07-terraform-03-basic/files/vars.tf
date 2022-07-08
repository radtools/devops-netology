#переменные

variable "zone" {
  default = "ru-central1-b"
}

variable "yandex-token" {
  default = "XXXXXXX"
}

variable "yandex-cloud-id" {
  default = "YYYYYYYY"
}

variable "yandex-folder-id" {
  default = "ZZZZZZZZ"
}

variable "instance_root_disk" {
  default = "10"
}

variable "instance_additional_disk" {
  default = "2"
}

variable "vm-name" {
  default = "ubuntu_test_srv"
}

variable "discpiption" {
  default = "my_ubuntu_test_srv"
}

variable "image-id" {
  default = "fd86ul0ci8ttbst35ln3" #Debian from yandex Market
}

variable "name-instance" {
  default = "Debian 11"
}

variable "desc-instance" {
  default = "deb_yc_template"
}

variable "buc_name" {
  default = "ya-buck"
}

variable "acces_key_buc" {
  default = "XYZXYZ"
}

variable "sec-key_buc" {
  default = "AAAAAAAAAAAAAAAAAAAAAAA"
}
