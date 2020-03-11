local uri_args = ngx.req.get_uri_args()
local productId = uri_args["productId"]
local shopId = uri_args["shopId"]

local backend = ""
local host = {"192.168.198.130", "192.168.198.131"}

local hotProductCacheKey = "hot_product_"..productId
local cache_ngx = ngx.shared.my_cache
local hotProductFlag = cache_ngx:get(hotProductCacheKey)

if hotProductFlag == "true" then
	math.randomseed(tostring(os.time()):reverse():sub(1,7))
	local index =  math.random(1,2)
	backend = "http://"..host[index]
else
	local hash = ngx.crc32_long(productId)
	local index = (hash % 2) + 1
	backend = "http://"..host[index]
end

local requestPath = uri_args["requestPath"]
requestPath = "/"..requestPath.."?productId="..productId.."&shopId="..shopId

local http = require("resty.http")
local httpc = http.new()

local resp, err = httpc:request_uri(backend, {
	method = "GET",
	path = requestPath,
	keepalive=false
})

if not resp then
	ngx.say("request error :", err)
	return
end

ngx.say(resp.body)

httpc:close()

