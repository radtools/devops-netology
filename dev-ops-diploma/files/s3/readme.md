Фаил _variables.tf_ содержит переменные для CloudID и FolderID Яндекс облака.  
_service_account_key_file = "../key.json"_ - генерируется через YC CLI  
В файле _main.tf_ описана процедура создания сервисного аккаунта (_s3account_) и создания бакета (_s3-buck_)  
