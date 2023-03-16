-- common package
local cjson = require('cjson')
local ctx_name = "mbr"
local dapps = ngx.shared.dapps;
local function is_empty(s)
  return s == nil or s == ""
end

local function get_context(key)
  return ngx.ctx[ctx_name] and ngx.ctx[ctx_name][key] or nil
end

local function set_context(key, value)
  if ngx.ctx[ctx_name] == nil then
    ngx.ctx[ctx_name] = {}
  end
  ngx.ctx[ctx_name][key] = value
end
  
local function get_apiinfo(api)
  local apiinfo = dapps:get(api)
  return apiinfo and cjson.decode(apiinfo) or nil
end

local function notfound() 
  ngx.status = 404
  ngx.header.content_type = 'application/json'
  ngx.print('{"Err":"Api not found"}')
  ngx.exit(404)
end

local common = {
  header_rpc_method = "X-Mbr-Rpc-Method",
  header_api_info = "X-Mbr-Api-Info",
  is_empty = is_empty,
  get_context = get_context,
  get_apiinfo = get_apiinfo,
  set_context = set_context,
  ctx_name = ctx_name,
  notfound = notfound,
}
return common