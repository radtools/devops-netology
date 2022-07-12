terraform {
backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "ya-buck"
    region     = "ru-central1"
    key        = "tfstate/terraform.tfstate"
    access_key = "YYYYYYYYYYY"
    secret_key = "ZZZZZZZZZZZ"

    
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
