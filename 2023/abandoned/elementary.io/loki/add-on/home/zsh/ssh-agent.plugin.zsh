
#       ssh-add $HOME/.ssh/${^identities}
        ls -1 /home/laptop/.ssh/*.pvk | xargs ssh-add
        ls -1 /home/brj/Dropbox/project/brj/private/ssh2017/ssh/*.pvk | xargs ssh-add
        
