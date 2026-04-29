[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/DelayStarter/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/DelayStarter/blob/master/README.RU.md) 
← Choose language | Выберите язык

# DelayStarter
Utility for launching applications after a countdown timer or upon internet connection. If the internet is unavailable, the apps will wait for a connection instead of launching immediately, displaying a countdown timer.

## Setup
1. Add the full paths of the required applications to `Apps.txt`. To pass launch arguments, use the `|` separator, e.g. `C:\Windows\System32\notepad.exe|C:\log.txt`. You can also use other files. To do this, use the `-f` launch parameter, for example: `DelayStarter -f apps2.txt`.
2. Add a shortcut of the application to Windows startup folder `%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`.
3. You can change the parameters and modes in the `Setup.ini` configuration file.

Parameter | Description
------------ | -------------
`WaitInternet` | Mode: `1` — launch apps after internet connection is detected, `0` — launch apps after the timer expires.
`WriteLaunchTime` | When using `WaitInternet=1`, saves the elapsed time to `LaunchTime` after internet is detected, so the timer shows an approximate wait time on next boot.
`LaunchTime` | Countdown timer. In `WaitInternet=0` mode — time after which apps are launched. In `WaitInternet=1` mode — shown as an approximate estimated wait time.
`PlaySound` | Play a sound when the timer expires or internet connection is detected.
`SoundFile` | Path to a `.wav` file. A Windows system sound can be used.

## Screenshots
![](https://github.com/user-attachments/assets/56fa9575-ce44-4bfd-80aa-7625876bd59e)
![](https://github.com/user-attachments/assets/4caab111-b33c-4ba5-ba1f-4f17c83eee3b)

## Download
>Supports Windows XP, 7, 8, 8.1, 10, 11.<br>
**[Download](https://github.com/r57zone/DelayStarter/releases)**

## Feedback
`r57zone[at]gmail.com`