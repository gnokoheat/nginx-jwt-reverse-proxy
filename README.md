# nginx-jwt-reverse-proxy
Nginx reverse proxy with JWT authentication

## Work flow
- Client -> Nginx (JWT Auth) -> Server

## Description
- jwt authentication
- return `X-Auth-UserId` header from `sub`
- gzip compression
- json type error response
- http method allowed only `GET, POST, PUT, DELETE`

## Usage
``` bash
docker run -d -p 80:80 --name nginx-jwt-reverse-proxy \
    -e JWT_SECRET=xxxxx \ # ex) secret
    -e BACKEND=xxxxx \ # ex) http://app:3000
    gnokoheat/nginx-jwt-reverse-proxy
```
