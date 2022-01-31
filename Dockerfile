FROM nginx

COPY Webpage2/nginx.config /etc/nginx/conf.d/default.conf
COPY Webpage2/index.html /usr/share/nginx/html
