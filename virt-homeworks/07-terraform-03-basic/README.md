# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
<details>
```
PS C:\Terraform\terra_for_each> terraform workspace list 
  default
* prod
  stage
```
</details>  
* Вывод команды `terraform plan` для воркспейса `prod`. 
<details>
```
PS C:\Terraform\terra_for_each> terraform plan -var-file prod.tfvars 
yandex_vpc_network.t-net: Refreshing state... [id=enpel15n4ehuq3bhq2qs]
yandex_vpc_subnet.subnet: Refreshing state... [id=e2llp7cn03scn4fbm053]
yandex_compute_instance.vmstudy-07-03["node2"]: Refreshing state... [id=epdp06mjm9k7nmt3glsk]
yandex_compute_instance.vmstudy-07-03["node1"]: Refreshing state... [id=epdnnk7bdodli1lfi7u7]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # yandex_compute_instance.vmstudy-07-03["node1"] has changed
  ~ resource "yandex_compute_instance" "vmstudy-07-03" {
        id                        = "epdnnk7bdodli1lfi7u7"
      + labels                    = {}
      + metadata                  = {}
        name                      = "vm-node1-prod"
      ~ status                    = "running" -> "stopped"
        # (9 unchanged attributes hidden)


      ~ network_interface {
          - nat_ip_address     = "158.160.1.9" -> null
            # (9 unchanged attributes hidden)
        }



        # (4 unchanged blocks hidden)
    }

  # yandex_compute_instance.vmstudy-07-03["node2"] has changed
  ~ resource "yandex_compute_instance" "vmstudy-07-03" {
        id                        = "epdp06mjm9k7nmt3glsk"
      + labels                    = {}
      + metadata                  = {}
        name                      = "vm-node2-prod"
      ~ status                    = "running" -> "stopped"
        # (9 unchanged attributes hidden)


      ~ network_interface {
          - nat_ip_address     = "158.160.1.25" -> null
            # (9 unchanged attributes hidden)
        }



        # (4 unchanged blocks hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these changes.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_storage_bucket.ya-buck will be created
  + resource "yandex_storage_bucket" "ya-buck" {
      + access_key            = "YCAJEa7l5UNIMcH0r4Zx_cJ46"
      + acl                   = "private"
      + bucket                = "ya-buck"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = (known after apply)
          + read = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
</details>
