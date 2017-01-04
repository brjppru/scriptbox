#!/bin/sh

# begin warn

go4it() {

read -r -p "Are you sure? [Y/n]" response
case "$response" in
    [yY][eE][sS]|[yY])
              #if yes, then execute the passed parameters
               echo "gotcha!"
               ;;
    *)
              #Otherwise exit...
              echo "ciao..."
              exit
              ;;
esac

}

clear

echo "moo! reboot atom?" | cowsay -d

echo "reboot"; go4it;

net rpc shutdown -r -f -I 192.168.18.137 -U brj%55555555


# ======================================================>
# The End ;-)
# ======================================================>
