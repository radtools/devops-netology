**INFO**

- Файл variables.tf - содержит переменные yandex cloud ID и yandex folder id, так же указание на использование переменных типа   
list из terafform.tfvars (в данном случае это переменные Зон и сетей (CIDR)  
- S3.tf - содержит информацию о бакете для сохранения tfstate файла (с указанием на переменные workspace)  
- networking.tf - информация о создаваемых сетях  
- image.tf - информация о том, какой образ будет использоваться при разворачивании VM
- dns.tf - информацию о том, какие ресурсные записи будут созданы при apply  
- в файлах с индеками 01-06 - содержиться информация о создаваемых VM (для экономии средств при выполнении тестовых запусков все 
машины "прерываемые" и "core_fraction" (базовый уровень производительности vCPU) установлен в 5%   

В целях экономии ресурсов Гитлаб и Гитлаб раннер запускаются на одной машине
