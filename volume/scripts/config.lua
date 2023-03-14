local cjson = require "cjson";
local upstreams = ngx.shared.upstreams;
local gw = ngx.shared._GW_;
local dapps = ngx.shared.dapps;

function secret_key_update(body) 
    gw:set("secretkey", body["secretKey"])
    ngx.say("OK: Updated secretKey successfully");
end 

function nodes_update(body) 
    local body_string = cjson.encode(body);
    ngx.log(ngx.ERR, body_string);
    upstreams:set("nodes", body_string);
    ngx.say("OK: Updated nodes list successfully");
end

function dapps_create(dapps) 
    -- Create new dapps
    local result = {};
    ngx.header["Content-type"] = 'application/json'
    ngx.say(#dapps)
    for i = 1, #dapps do
        local dapp = dapps[i]
        local success, err, forcible = dapps:add(dapp.id, cjson.encode(dapp))
        if success then
        result[dapp.id] = "OK"
        else
        result[dapp.id] = "ERR:" .. err
        end   
    end  
    local output = cjson.encode(result)
    ngx.say(output)
end

function dapps_update(dapps) 
    -- Update dapps
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
end    

function dapps_delete(dapps) 
    -- Delete dapps
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
end

function notfound() 
    ngx.status = 404
    ngx.header.content_type = 'application/json'
    ngx.print('{"Err":"Api not found"}')
    ngx.exit(404)
end

local function handler() 
    local request_uri = ngx.var.request_uri;
    -- ngx.log(ngx.ERR, "Request uri:".. request_uri)
    -- get request content
    ngx.req.read_body()
    local success, json_body = pcall(cjson.decode, ngx.var.request_body)
    if not success then
        ngx.log(ngx.ERR, "invalid JSON request")
        ngx.
        ngx.exit(ngx.HTTP_BAD_REQUEST)
        return
    end
    ngx.log(ngx.ERR, "Request Body:".. cjson.encode(json_body))
    
    local p1, p2 = request_uri:match('/config/([-_a-zA-Z0-9]+)/([-_a-zA-Z0-9]+)')  
    if p1 == "dapps" then 
        if p2 == "create" then
            dapps_create(json_body)
        elseif p2 == "update" then
            dapps_update(json_body)
        elseif p2 == "delete" then
            dapps_delete(json_body)
        else 
            notfound()
        end            
    elseif p1 == nil then
        local p1 = request_uri:match('/config/([-_a-zA-Z0-9]+)')
        if p1 == "secret-key" then
            secret_key_update(json_body)
        elseif p1 == "nodes" then
            nodes_update(json_body)
        else 
            notfound()
        end 
    else 
        notfound()
    end    
end

return handler