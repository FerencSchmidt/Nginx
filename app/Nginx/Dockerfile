FROM ubuntu

ENV NGINX_VERSION 1.8.0

RUN apt-get update && apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev wget

RUN mkdir installers \
		&& cd installers \
		&& wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
		&& tar zxf nginx-${NGINX_VERSION}.tar.gz \
		&& cd nginx-${NGINX_VERSION} \
		&& ./configure \
		&& make \
		&& make install

RUN mkdir /usr/local/nginx/html/public && echo "FREE FOR ALL" > /usr/local/nginx/html/public/index.html
RUN echo "admin:NtBG44z9ndAs6" > /usr/local/nginx/conf/htpasswd
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

WORKDIR "/usr/local/nginx"
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
