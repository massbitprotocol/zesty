local cjson = require("cjson");
local common = require("mbr/common");
local auth = require("mbr/auth")
local config = require("mbr/config")
local request = require("mbr/request")


local function set_context() 
  ngx.log(ngx.ERR, "api" .. ngx.var.api)
  ngx.var.api = string.sub(ngx.var.request_uri, 2, string.len(ngx.var.request_uri));
  local apiinfo = common.get_apiinfo(ngx.var.api)
  if apiinfo ~= nil then
    ngx.var.user_id = apiinfo.user_id;
  else
    ngx.log(ngx.ERR, "Api notfound: " .. ngx.var.api)  
  end  
  -- ngx.var.api_method = "rpc_method"
end

local main = {
  auth = auth,
  --set_context = set_context,
  get_proxy = request.get_proxy,
  filter_rpc_body = request.filter_rpc_body,
  handle_config = config,
}
return main