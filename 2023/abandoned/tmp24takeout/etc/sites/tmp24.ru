server {
    listen 80;
    server_name tmp24.ru tmp24.elcasa.org tmp24.brj.pp.ru;
    access_log  /var/log/nginx/access.log;

    location / {
        proxy_pass http://127.0.0.1:8001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /files/ {
        alias /srv/files/;
    }

    location /robots.txt {
        alias /srv/krasweather/app/static/robots.txt;
    }

    location /yandex_5d72e36d76b30f4b.txt {
        alias /srv/krasweather/app/static/yandex_5d72e36d76b30f4b.txt;
    }
    location /yandex_66cb260c0c88884e.txt {
        alias /srv/krasweather/app/static/yandex_66cb260c0c88884e.txt;
    }
}

