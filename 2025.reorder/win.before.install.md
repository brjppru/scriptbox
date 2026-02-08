# gpt before install

GPT. В окне управления дисками нажмите  shift + F10, в командной строке очистите диск и конвертируйте в GPT, потом обновите информацию в окне.

```
diskpart
sel dis 0
clean
convert gpt
exit
```
