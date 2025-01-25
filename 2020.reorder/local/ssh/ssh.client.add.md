in .ssh/config

Host *
    ControlMaster auto
    ControlPath ~/.ssh/master-%r@%h:%p.socket
    ControlPersist 30m
