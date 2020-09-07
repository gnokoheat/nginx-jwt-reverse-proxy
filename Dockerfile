FROM openresty/openresty:alpine-fat

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-jwt
COPY nginx-jwt.lua /usr/local/openresty/nginx/nginx-jwt.lua
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

ENV JWT_SECRET=secret
ENV BACKEND=http://app:3000

EXPOSE 80