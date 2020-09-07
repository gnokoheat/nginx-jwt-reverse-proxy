local jwt = require "resty.jwt"
local cjson = require "cjson"
local secret = os.getenv("JWT_SECRET")

assert(secret ~= nil, "Environment variable JWT_SECRET not set")

local validators = require "resty.jwt-validators"
local claim_spec = {}

-- require Authorization request header
local auth_header = ngx.var.http_Authorization

if auth_header == nil then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\":{\"code\":401,\"message\":\"No Authorization header\"}}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- require Bearer token
local _, _, token = string.find(auth_header, "Bearer%s+(.+)")

if token == nil then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\":{\"code\":401,\"message\":\"Missing token\"}}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- require valid JWT
local jwt_obj = jwt:verify(secret, token, claim_spec)
if jwt_obj.verified == false then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\":{\"code\":401,\"message\":\"Invalid token\"}}")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- write the X-Auth-UserId header
ngx.header["X-Auth-UserId"] = jwt_obj.payload.sub