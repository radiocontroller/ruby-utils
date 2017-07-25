# 用于创建密码的BCrypt gem, 我们可以直接使用它, 在Rails和Devise中都已经默认包含了

def get_secure_password(password)
   BCrypt::Password.create(password).to_s
end

def check_password(password, hash)
  BCrypt::Password.new(hash) == password
end
