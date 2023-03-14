local cjson = require "cjson";
local dapps = ngx.shared.dapps;

function dapps_create(dapps) {
  -- Create new dapps
  local result = {};
  for i = 1, #dapps do
    local dapp = dapps[i]
    local success, err, forcible = dapps:add(dapp.id, cjson.encode(dapp))
    if success then
      result[dapp.id] = "OK"
    else
      result[dapp.id] = "ERR:" .. err
    end   
  end  
  ngx.header["Content-type"] = 'application/json'
  local output = cjson.encode(result)
  ngx.say(output)
} 

function dapps_update(dapps) {
  -- Create update dapps
  local result = {};
  for i = 1, #dapps do
    local dapp = dapps[i]
    local success, err, forcible = dapps:set(dapp.id, cjson.encode(dapp))
    if success then
      result[dapp.id] = "OK"
    else
      result[dapp.id] = "ERR:" .. err
    end   
  end  
  ngx.header["Content-type"] = 'application/json'
  local output = cjson.encode(result)
  ngx.say(output)
}

function dapps_delete(dapps) {
  -- Create update dapps
  local result = {};
  for i = 1, #dapps do
    local success, err, forcible = dapps:delete(dapp.id, nil)
    if success then
      result[dapp.id] = "OK"
    else
      result[dapp.id] = "ERR:" .. err
    end   
  end  
  ngx.header["Content-type"] = 'application/json'
  local output = cjson.encode(result)
  ngx.say(output)
}
-- get request content
ngx.req.read_body()
local success, dapps = pcall(cjson.decode, ngx.var.request_body)
if not success then
    ngx.log(ngx.ERR, "invalid JSON request")
    ngx.exit(ngx.HTTP_BAD_REQUEST)
    return
end

local method_name = ngx.var.method;
if method_name == "create" then
  dapps_create(dapps)
elseif method_name == "update" then
  dapps_update(dapps)
elseif method_name == "delete" then
  dapps_delete(dapps)
end
