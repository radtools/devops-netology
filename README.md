# devops-netology
#first coment
ls -la (show hiden dirs)
#будут игнорированы локальные директории тераформ (любой степени вложенности)
#любые файлы с расширением tfstate и производные от этого файла (bak,log e.t.c)
#файл дампа "падений"
#любые файлы содержащие "критичные" переменные (как то токены\пароли и пр) с расширением *.tfvars
#файлы override.tf, override.tf.json а так же файлы по маске этих файлов
#файлы конфигурации CLI (.terraform и .teraraform.rc)

