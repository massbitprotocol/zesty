local cjson = require "cjson";
local upstreams = ngx.shared.upstreams;

-- Return next datasource and assign to proxy

function get_next_upstream() 
  local node_string = upstreams:get("nodes");
  if (node_string == nil) 
  then
    ngx.log(ngx.ERR, "Node notfound");
    ngx.exit(ngx.HTTP_NOT_FOUND);
  else 
    local nodes = cjson.decode(node_string);
    if (nodes and #nodes > 0) 
    then 
      return nodes[1]["dataSource"];
    end    
  end
end

ngx.var.proxy = get_next_upstream();
-- ngx.log(ngx.ERR, ngx.var.proxy);


