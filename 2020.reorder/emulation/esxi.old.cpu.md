# ESXi old cpu md

ESXi 7.0 больше не хочет устанавливаться на старом оборудовании

- Intel Family 6, Model = 2C (Westmere-EP)
- Intel Family 6, Model = 2F (Westmere-EX)

Далее при загрузке установщика ESXi с CD-ROM или ISO нужно нажать комбинацию клавиш Shift + <O> (это буква, а не ноль), после чего появится приглашение ко вводу. Надо ввести вот такую строчку в дополняемую строку:

```
allowLegacyCPU=true
```

После того, как ESXi установится на ваш сервер, вам нужно будет снова нажать Shift + <O> и повторно вбить указанный выше параметр при первом запуске:

Теперь нужно сделать так, чтобы данный параметр добавлялся при каждой загрузке ESXi. Сначала включим сервисы командной строки ESXi и удаленного доступа по SSH. Для этого нужно запустить службы TSM и TSM-SSH на хосте ESX

Далее подключаемся к ESXi по SSH и с помощью следующей команды находим файл конфигурации загрузки:

```
find / -name "boot.cfg
```

Далее добавляем в него параметр allowLegacyCPU=true в разделе kernelopt