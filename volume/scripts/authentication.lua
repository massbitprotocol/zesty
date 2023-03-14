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

local function authenticate()
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
end

return authenticate