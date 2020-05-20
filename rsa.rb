# 2048长度（也可1024）
key = OpenSSL::PKey::RSA.generate(2048)
key.to_pem是私钥
key.to_s是公钥

# 用pkcs1格式处理
str = "plain text"
pkcs1 = "MIIEpAIBAAKCAQEAlSUpLZegT21zKX....=="
digest = OpenSSL::Digest::SHA256.new
pkey = OpenSSL::PKey::RSA.new(Base64.decode64(pkcs1))
signature = URI.encode_www_form_component(Base64.strict_encode64(pkey.sign(digest, str)))
