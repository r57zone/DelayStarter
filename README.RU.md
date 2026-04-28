[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/DelayStarter/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/DelayStarter/blob/master/README.RU.md) 

# DelayStarter
Приложение для запуска других программ после окончания таймера или после подключения к интернету. Если интернет недоступен - программы не запустятся сразу, а дождутся соединения, отображая обратный таймер.

## Настройка
1. Добавьте полные пути необходимых приложений в файл `Apps.txt`. При необходимости добавления параметров запуска используйте разделитель `|`, например, `C:\Windows\System32\notepad.exe|C:\log.txt`
2. Добавьте ярлык приложения в автозапуск Windows `%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`.
3. В файле конфигурации `Setup.ini` можно изменить параметры и режимы работы.

Параметр | Описание
------------ | -------------
`WaitInternet` | Режим работы: `1` - запуск программ после появления интернета, `0` - запуск программ по истечении таймера.
`WriteLaunchTime` | При использовании режима `WaitInternet=1`, после обнаружения интернет-соединения происходит запись таймера `LaunchTime`, для отображения приблизительного времени ожидания.
`LaunchTime` | Таймер отсчёта. Для режима `WaitInternet=0` время после которого запустятся программы, при `WaitInternet=1` выводит время просто для приблизительного ожидания.
`PlaySound` | Воспроизведение звука по истечении таймера или обнаружения интернет-соединения.
`SoundFile` | Путь до звукового wav файла, можно указать один из системных звуков.

## Скриншоты
![](https://github.com/user-attachments/assets/98f6029b-5673-41f3-954c-d20c3a3307da)
![](https://github.com/user-attachments/assets/cee6911c-ce54-4889-af96-5e21daf070c3)

## Загрузка
>Поддерживается Windows XP, 7, 8, 8.1, 10, 11.<br>
**[Загрузить](https://github.com/r57zone/DelayStarter/releases)**

## Обратная связь
`r57zone[собака]gmail.com`