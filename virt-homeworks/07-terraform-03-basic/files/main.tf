terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "<имя бакета>"
    region     = "ru-central1"
    key        = "<путь к файлу состояния в бакете>/<имя файла состояния>.tfstate"
    access_key = "<идентификатор статического ключа>"
    secret_key = "<секретный ключ>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  #переменные для доступа к облаку
  token     = "${var.yandex-token}"  #API токен
  cloud_id  = "${var.yandex-cloud-id}" #ID облака
  folder_id = "${var.yandex-folder-id}" #ID каталога
  zone      = "${var.zone}" #зона для хостинга ВМ
}
