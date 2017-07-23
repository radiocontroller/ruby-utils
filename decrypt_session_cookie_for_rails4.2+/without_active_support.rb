require 'openssl'
require 'base64'
require 'cgi'
require 'json'

def verify_and_decrypt_session_cookie cookie, secret_key_base
  cookie = CGI.unescape(cookie)

  #################
  # generate keys #
  #################
  encrypted_cookie_salt = 'encrypted cookie' # default: Rails.application.config.action_dispatch.encrypted_cookie_salt
  encrypted_signed_cookie_salt = 'signed encrypted cookie' # default: Rails.application.config.action_dispatch.encrypted_signed_cookie_salt
  iterations = 1000
  key_size = 64
  secret = OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret_key_base, encrypted_cookie_salt, iterations, key_size)
  sign_secret = OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret_key_base, encrypted_signed_cookie_salt, iterations, key_size)

  ##########
  # Verify #
  ##########
  data, digest = cookie.split('--')
  raise 'invalid message' unless digest == OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, sign_secret, data)
  # you better use secure compare instead of `==` to prevent time based attact,
  # ref: ActiveSupport::SecurityUtils.secure_compare

  ###########
  # Decrypt #
  ###########
  encrypted_message = Base64.strict_decode64(data)
  encrypted_data, iv = encrypted_message.split('--').map{|v| Base64.strict_decode64(v) }
  cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  cipher.decrypt
  cipher.key = secret
  cipher.iv  = iv
  decrypted_data = cipher.update(encrypted_data)
  decrypted_data << cipher.final

  JSON.load(decrypted_data)
end
