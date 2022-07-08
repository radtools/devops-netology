resource "yandex_storage_bucket" "ya-buck" {
  access_key = var.acces_key_buc
  secret_key = var.sec-key_buc
  bucket = var.buc_name

 # lifecycle {
 #       prevent_destroy = true
 #   }

 #   versioning {
 #       enabled = true
 #   }
}
