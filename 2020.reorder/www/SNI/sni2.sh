#!/bin/sh

openssl s_client -connect www.amsterdam.nl:443 < /dev/null | openssl x509 -noout -text | grep DNS:
