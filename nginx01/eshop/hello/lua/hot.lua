local uri_args = ngx.req.get_uri_args()
local productId = uri_args["productId"]
local productInfo = uri_args["productInfo"]

local productCacheKey = "productInfo_"..productId
local cache_ngx = ngx.shared.my_cache
cache_ngx:set(productCacheKey,productInfo,3600)

