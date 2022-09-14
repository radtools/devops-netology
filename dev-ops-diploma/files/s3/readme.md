Фаил variables.tf содержит переменные для CloudID и FolderID Яндекс облака.  
service_account_key_file = "../key.json" - генерируется через YC CLI  
В файле main.tf описана процедура создания сервисного аккаунта (s3account) и создания бакета (s3-buck)  
