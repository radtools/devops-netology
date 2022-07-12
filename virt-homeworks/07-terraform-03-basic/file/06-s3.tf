terraform {
backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "ya-buck"
    region     = "ru-central1"
    key        = "tfstate/terraform.tfstate"
    access_key = "YCAJEa7l5UNIMcH0r4Zx_cJ46"
    secret_key = "YCNCNoufrfBeIJ5f912RPnY0ywVKyCt-g-yOLNHH"

    
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}