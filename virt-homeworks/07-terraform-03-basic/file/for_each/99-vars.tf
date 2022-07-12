#переменные
#oAuth_vars
variable "zone" {
  type = string
}

variable "yandex-token" {
  type = string
}

variable "yandex-cloud-id" {
  type = string
}

variable "yandex-folder-id" {
  type = string
}
#Disk_vars
variable "instance_root_disk" {
  type = number
}

variable "instance_additional_disk" {
  type = number
}
#VM_name_vars
variable "vm-name" {
  type = string
}

variable "discpiption" {
  type = string 
}

#Image_ID_yandexMarket
variable "image-id" {
  type = string
}

#bucket_vars
variable "buc_name" {
  type = string
}

variable "acces_key_buc" {
  type = string
}

variable "sec-key_buc" {
  type = string
}

variable "instance_count" {
  type        = number
}
variable "cores" {
  type        = number
}
variable "mem" {
  type        = number
}
variable "fraction" {
  type        = number
}
variable "subnet" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "id" {
  type = list
}