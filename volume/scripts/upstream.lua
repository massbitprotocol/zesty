local upstream = require "ngx.upstream"
local balancer = require "ngx.balancer"
local cjson = require "cjson";
local upstreams = ngx.shared.upstreams;
local get_servers = upstream.get_servers
local set_peer_down = upstream.set_peer_down

local curr_ups = upstream.current_upstream_name()
-- local srvs = get_servers(curr_ups)
local srvs = {}
srvs[1] = {};
srvs[1]["name"] = "node1";
srvs[1]["addr"] = "3.218.107.208";
srvs[2] = {};
srvs[2]["name"] = "https://rpc.ethereum.forbole.com/";
srvs[2]["addr"] = "104.26.4.50";
local function get_next_upstream() 
  local nodes = upstreams:get("nodes");
  return #nodes > 0 and nodes[0] or nil;
end
-- well, usually we calculate the peer's host and port
-- according to some balancing policies instead of using
-- hard-coded values like below
local host = "127.0.0.2"
local port = 80

local ok, err = balancer.set_current_peer(srvs[1]["addr"], port)
if not ok then
    ngx.log(ngx.ERR, "failed to set the current peer: ", err)
    return ngx.exit(500)
end
local next_upstream = get_next_upstream();
if next_upstream then
  local ok, err = balancer.set_current_peer(next_upstream["datasource"])
end
