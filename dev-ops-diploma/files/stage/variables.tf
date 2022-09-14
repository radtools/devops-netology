
variable "yandex_cloud_id" {
  default = "b1gp79eqhedrffiqjlhk"
}

variable "yandex_folder_id" {
  default = "b1grkimcimnco8bilkh9"
}

variable "zones" {
  type    = list(string)
}

variable "cidr" {
  type    = list(string)
}