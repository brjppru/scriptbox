# proxy

## apt

```
sudo cat <<EOF >>/etc/apt/apt.conf.d/proxy.conf
Acquire::http::Proxy "http://user@example.com:somePassword@proxy.example.com:7777";
EOF
```

## curl

```
cat <<EOF >> ~/.profile
export http_proxy=http://user:somePassword@proxy.example.com:7777
EOF
```

```
cat <<EOF >> ~/.curlrc
proxy-user=user@example.com:somePassword
proxy=http://proxy.example.com:7777
EOF
```

## wget

```
cat <<EOF >> ~/.wgetrc
proxy-user=user@example.com
proxy-password=somePassword
http_proxy=http://proxy.example.com:7777
use_proxy=on
EOF
````

## git

```
git config --global http.proxy "http://user@example.com:somePasswrod@proxy.example.com:7777"
```

## npma

```
npm set proxy http://user@example.com:somePassword@proxy.example.com:7777/
npm set https-proxy http://user@example.com:somePassword@proxy.example.com:7777/
```
