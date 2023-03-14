-- OpenResty ships with a number of useful built-in libraries
local str = require('resty.string')
local sha256 = require('resty.sha256')
local dapps = ngx.shared.dapps; 
local secret = "it's over 9000!"

-- a helper function, probably useful to have a 'response.lua' file
-- and do something like:
--   local response = requre('response')
-- (inlined here though for completeness)
local function notAuthorized()
  ngx.status = 401
  ngx.header.content_type = 'application/json'
  ngx.print('{"error":"not authorized"}')
  ngx.exit(401)
end

local function notfound() 
  ngx.status = 404
  ngx.header.content_type = 'application/json'
  ngx.print('{"Err":"Api not found"}')
  ngx.exit(404)
end
local function authenticate_v1(api) 
  ngx.log(ngx.NOTICE, "Call authenticate for api" .. api)
  local apiInfo = dapps:get(api);
  if apiInfo == nil then
    ngx.log(ngx.ERR, "Api notfound: " .. api or "")
    notfound()
  end  
  --[[
  local auth = ngx.var.http_authorization
  if auth == nil or auth:sub(0, 7) ~= 'SHA256 ' then
    return notAuthorized()
  end

  -- force nginx to read the body, without this, get_body_data() will return nil
  ngx.req.read_body()
  local msg =  secret .. ngx.var.request_uri
  local body = ngx.req.get_body_data()
  if body ~= nil then
     msg = msg .. body
  end

  local hasher = sha256:new()
  hasher:update(msg)
  if auth:sub(8) ~= str.to_hex(hasher:final()) then
    return notAuthorized()
  end
  ]]--
end

local function authenticate()
  local v, api = ngx.var.request_uri:match('/api/([-_a-zA-Z0-9]+)/([-_a-zA-Z0-9]+)')  
  if v == "v1" and api ~= nil then 
    authenticate_v1(api)
  else
    notfound()
  end    
end

return authenticate