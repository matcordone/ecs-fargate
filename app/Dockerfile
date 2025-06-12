FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html

COPY stress.sh /stress.sh

RUN chmod +x /stress.sh

EXPOSE 80

