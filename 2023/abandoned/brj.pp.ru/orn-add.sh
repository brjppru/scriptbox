#!/bin/sh

# curl -sSL https://brj.pp.ru/orn-add.sh | sh

mkdir -p /root/.ssh/
chmod 700 /root/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgnQxBsXR+i7ACqo6IVd/RElFeHRV04yjYy9c/tq96Y+bMti6xgsamhBB6m51WH9I6mviwJUmUCfOr3QD+2ywH1CExEDZ3ewZ5FWYqmXL1doIhskXKGWhDnDwOF+t2CjHxQV9a/mhDbZijBqeL6T38Q9ipB5AOQNohkCTWYranaouIqTA91I64K33IItq5ynngtLaCV1IHn/hc7Z9Qi3W/0ozm1u6OOycknbp1+DJOweHh5VZ4OA1VXctedvWSkz7Wqa0vxeuppA1EbnAQuo8fH99edmTD4/0KmwdnF90XALx6QuKqz7OZ/9QQ06fAK37z8wk26VznGX+eKLCZwfBVw== ORN-brj-key-20180131" >> /root/.ssh/authorized_keys

chmod 600  /root/.ssh/authorized_keys

echo ORN-brj-key-20180131.key

