# Prevent packages from being updated under Ubuntu / Debian

```
user@system:~$ sudo apt-mark hold <name of the package>
```

```
user@system:~$ sudo apt-mark hold vlc
user@system:~$ sudo aptitude hold vlc
```

```
user@system:~$ sudo apt-mark unhold vlc
user@system:~$ sudo aptitude unhold vlc
```

You may ask yourself why you should hold a package anyway. Well, there are several reasons to do this. For e.g. sometimes you update a package and after this update the software doesn’t work as expected. So if you encounter a problem after an update on a test system, you could hold / block the specific package which causes you trouble on a production system before updating the system. Another example would be that you might have to check the configuration files first before updating a specific software. However, you want to install the latest security updates for the other installed packages. With holding the package you can update the other packages without touching the once you block.
