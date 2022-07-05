# Proxmox Provider
# ---
# Стартовая конфигурация провайдера ЯО

terraform {
  required_providers { #требуемый провайдер
    yandex = {
      source = "yandex-cloud/yandex" #наименование источника провайдера
    }
  }
  required_version = ">= 0.13" #требуемая минимальная версия терраформ
}
  
provider "yandex" {
  #переменные для доступа к облаку
  token     = "${var.yandex-token}"  #API токен
  cloud_id  = "${var.yandex-cloud-id}" #ID облака
  folder_id = "${var.yandex-folder-id}" #ID каталога
  zone      = "${var.zone}" #зона для хостинга ВМ
}
