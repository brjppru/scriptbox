# putty 256 #


1. Configure Putty
In Settings > Windows > Colours there is a check box for "Allow terminal to use xterm 256-colour mode".

2. Let the app know
You'll probably have to change Settings -> Connection > Data > Terminal-type string to:

xterm-256color

if your server has a terminfo entry for putty-256color, typically in /usr/share/terminfo/p/putty-256color, you can set Putty's Terminal-Type to putty-256color instead.

The main thing here is to make the server use an available Terminfo entry that most closely matches the way Putty is configured.

