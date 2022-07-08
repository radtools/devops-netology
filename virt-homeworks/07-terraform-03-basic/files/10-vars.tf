#переменные
###########
#начинаются тут
variable "zone" {
  default = "ru-central1-b"
}
#oAuth_vars

variable "yandex-token" {
  default = "zzzzzzz"
}
#cloud_id_var
variable "yandex-cloud-id" {
  default = "1234567"
}
#folder_id_var
variable "yandex-folder-id" {
  default = "xyzxyzxyz"
}
#Disk_vars
variable "instance_root_disk" {
  default = "10"
}

variable "instance_additional_disk" {
  default = "2"
}
#VM_name_vars

variable "vm-name" {
  default = "debian-srv"
}

variable "discpiption" {
  default = "my_Debian_test_srv"
}
#Image_ID_yandexMarket

variable "image-id" {
  default = "fd86ul0ci8ttbst35ln3"
}

#bucket_vars
#
#
variable "buc_name" {
  default = "ya-buck"
}

variable "acces_key_buc" {
  default = "supersecretkey"
}

variable "sec-key_buc" {
  default = "secretsuperkey"
}
