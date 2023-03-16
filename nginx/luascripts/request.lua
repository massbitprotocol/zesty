local cjson = require("cjson");
local common = require("mbr/common");

local upstreams = ngx.shared.upstreams;

-- Return next datasource and assign to proxy
local function filter_rpc_body()
  local version, api = ngx.var.request_uri:match('/api/([-_a-zA-Z0-9]+)/([-_a-zA-Z0-9]+)')
  local apiinfo = api and common.get_apiinfo(api) or nil
  if apiinfo ~= nil then
    ngx.req.set_header(common.header_api_info, cjson.encode(apiinfo))
    ngx.var.api = api;
    ngx.var.user_id = apiinfo.user_id;
  else
    ngx.log(ngx.ERR, "Api notfound: " .. (api or ""))  
    common.notfound()
    return
  end
  -- get request content
  ngx.req.read_body()

  -- try to parse the body as JSON
  local success, body = pcall(cjson.decode, ngx.var.request_body)
  if not success then
      ngx.log(ngx.ERR, "invalid JSON request")
      ngx.exit(ngx.HTTP_BAD_REQUEST)
      return
  end

  local method = body["method"]
  local version = body["jsonrpc"]

  -- check we have a method and a version
  if common.is_empty(method) or common.is_empty(version) then
      ngx.log(ngx.ERR, "Missing method and/or jsonrpc attribute")
      ngx.exit(ngx.HTTP_BAD_REQUEST)
      return
  end

  -- check the version is supported
  --[[
  if version ~= "2.0" then
      ngx.log(ngx.ERR, "jsonrpc version not supported: " .. version)
      ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
      return
  end
  ]] --
  ngx.var["api_method"] = method
  ngx.req.set_header(common.header_rpc_method, method)
end

local function get_proxy()
  ngx.var.api_method = ngx.req.get_headers()[common.header_rpc_method]
  ngx.req.clear_header(common.header_rpc_method)
  local api_info = ngx.req.get_headers()[common.header_api_info]
  ngx.req.clear_header(common.header_api_info)
  ngx.log(ngx.ERR, "request uri:" .. ngx.var.request_uri)
  if api_info ~= nil then
    local api = cjson.decode(api_info)
    ngx.var.api = api.id;
    ngx.var.user_id = api.user_id;
  else
    ngx.log(ngx.ERR, "Api notfound in header: " .. (api or ""))  
    return
  end
  local node_string = upstreams:get("nodes");
  if (node_string == nil) 
  then
    ngx.log(ngx.ERR, "Node notfound");
    return nil
    -- ngx.exit(ngx.HTTP_NOT_FOUND);
  else 
    local nodes = cjson.decode(node_string);
    if (nodes and #nodes > 0) 
    then 
      math.randomseed(os.time())
      local index = math.random(#nodes)
      local node = nodes[index];
      if node == nill then
        ngx.log(ngx.ERR, "Cannot get datasource at index : " .. index)
      else  
        ngx.log(ngx.ERR, "Use datasource at index : " .. index .. ":" .. node["datasource"])
        ngx.var.node_id = node["id"]
        return node["datasource"]
      end  
    end    
  end
end

local request = {
  get_proxy = get_proxy,
  filter_rpc_body = filter_rpc_body,
}
return request