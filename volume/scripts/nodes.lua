local cjson = require "cjson";
local upstreams = ngx.shared.upstreams;

-- get request content
ngx.req.read_body()
-- local request_uri = ngx.var.request_uri;
-- local payload = ngx.req.get_body_data();
-- local success, body = cjson.decode(payload)
-- try to parse the body as JSON
local success, body = pcall(cjson.decode, ngx.var.request_body)
if not success then
    ngx.log(ngx.ERR, "invalid JSON request")
    ngx.exit(ngx.HTTP_BAD_REQUEST)
    return
end
local body_string = cjson.encode(body);
ngx.log(ngx.ERR, body_string);
upstreams:set("nodes", body_string);
ngx.say("Updated nodes list successfully");