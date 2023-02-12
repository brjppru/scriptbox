#!/bin/sh

#
# the brj elementary bolgenos script ;-)
# http://brj.pp.ru/
#

sudo apt-get -y install git zsh fonts-powerline
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
sudo chsh -s $(which zsh) $(whoami)
sudo chsh -s /bin/zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sudo fc-cache -f -v

#git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
#Add the plugin to the list of plugins for Oh My Zsh to load:

#plugins=(zsh-autosuggestions)
