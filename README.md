# devops-netology
#first coment<br>
ls -la (show hiden dirs)<br>
#будут игнорированы локальные директории тераформ (любой степени вложенности)<br>
#любые файлы с расширением tfstate и производные от этого файла (bak,log e.t.c)<br>
#файл дампа "падений"<br>
#любые файлы содержащие "критичные" переменные (как то токены\пароли и пр) с расширением *.tfvars<br>
#файлы override.tf, override.tf.json а так же файлы по маске этих файлов<br>
#файлы конфигурации CLI (.terraform и .teraraform.rc)<br><br>
#end<br>
__________________________________________________________________

#home_work 02-git-04<br>
<br>
#Q1<br>
Решение: git show aefea<br> 
Ответ: commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545<br>
Update CHANGELOG.md<br>
<br>
#Q2<br>
Решение: git show 85024<br>
Ответ: commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)<br>
<br>
#Q3<br>
Решение: git show b8d720<br>
Ответ:2<br>
Хэши: 56cd7859e && 9ea88f22f<br> 
<br>
#Q4<br>
Решение: git log  v0.12.23..v0.12.24<br>
Ответ:<br>
1)33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24<br>
2)b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links<br>
3)3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md<br>
4)6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable<br>
5)5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location<br>
6)06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md<br>
7)d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows<br>
8)4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md<br>
9)dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md<br>
10)225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release<br>
<br>
#Q5<br>
Решение: git log -S'func providerSource' --oneline<br>
Ответ:<br>
1)5af1e6234 main: Honor explicit provider_installation CLI config when present<br>
2)8c928e835 main: Consult local directories as potential mirrors of providers<br>
<br>
#Q6<br>
Решение: git log -L :'func globalPluginDirs':plugins.go --oneline<br>
Ответ: <br>
1)78b12205587fe839f10d946ea3fdc06719decb05 Remove config.go and update things using its aliases<br>
2)52dbf94834cb970b510f2fba853a5b49ad9b1a46 keep .terraform.d/plugins for discovery<br>
3)41ab0aef7a0fe030e84018973a64135b11abcd70 Add missing OS_ARCH dir to global plugin paths<br>
4)66ebff90cdfaa6938f26f908c7ebad8d547fea17 move some more plugin search path logic to command<br>
5)8364383c359a6b738a436d1b7745ccdce178df47 Push plugin discovery down into command package<br>
<br>
#Q7<br>
Решение: git log -S'func synchronizedWriters'<br>
Ответ: <br>
1)bdfea50cc - James Bardin j.bardin@gmail.com (author - remove unused)<br>
2)5ac311e2a - Martin Atkins mart@degeneration.co.uk (author add feature)<br>
