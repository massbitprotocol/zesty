local cjson = require "cjson";
local upstreams = ngx.shared.upstreams;

-- Return next datasource and assign to proxy

local function get_next_upstream() 
  local node_string = upstreams:get("nodes");
  if (node_string == nil) 
  then
    ngx.log(ngx.ERR, "Node notfound");
    ngx.exit(ngx.HTTP_NOT_FOUND);
  else 
    local nodes = cjson.decode(node_string);
    if (nodes and #nodes > 0) 
    then 
      math.randomseed(os.time())
      local index = math.random(#nodes)
      ngx.log(ngx.ERR, "Use datasource at index : " .. index .. ":" .. nodes[index]["dataSource"])
      return nodes[index]["dataSource"]
    end    
  end
end
return get_next_upstream



