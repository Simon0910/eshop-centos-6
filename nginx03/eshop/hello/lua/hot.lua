local uri_args = ngx.req.get_uri_args()
local productId =uri_args["productId"]

local cache_ngx = ngx.shared.my_cache

local hotProductCacheKey = "hot_product_"..productId

cache_ngx:set(hotProductCacheKey, "true", 3600)
