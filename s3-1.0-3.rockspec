package = "s3"
version = "1.0-3"

source = {
   url = "git://github.com/gcr/lua-s3",
}

description = {
   summary = "A simple S3 API to upload and download objects",
   homepage = "https://github.com/gcr/lua-s3"
}

dependencies = {
   "lua-resty-hmac",
   "luacrypto",
   "lua-cjson",
   "date",
}

build = {
   type = "builtin",
   modules = {
      ['s3.init'] = 'init.lua',
   }
}