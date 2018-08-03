require 'jwt'

class Auth
  ALGORITHM = 'HS256'
  def self.issue(payload)
    JWT.encode payload, auth_secret, ALGORITHM
  end
  def self.decode(token)
    begin
      decoded_token = (JWT.decode token, auth_secret, true, { algorithm: ALGORITHM }).first
      return { success: true, decoded_token: decoded_token, msg: 'You\'re authorized'}
    rescue JWT::ExpiredSignature
      return { success: false, msg: 'Token has been expired' }
    rescue JWT::DecodeError
      return { success: false, msg: 'Not enough or too many segments' }
    end
    # JWT.decode token, auth_secret, true, { algorithm: ALGORITHM }
  end
  def self.auth_secret
    ENV["AUTH_SECRET"]
  end

  def self.salt
    bin_to_hex(OpenSSL::Random.random_bytes(len))
  end

  def self.issueHash(password, pass_salt)
    hash = OpenSSL::PKCS5.pbkdf2_hmac(password, pass_salt, iter, len, digest)
    bin_to_hex(hash)
  end

  def self.token(request)
    request.headers.env['HTTP_X_ACCESS_TOKEN'] || !!request.headers.env['HTTP_ACCESS_TOKEN'] || request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last 
  end
  
  def self.auth_present?(request)
    !!request.headers.env['HTTP_X_ACCESS_TOKEN'] || !!request.headers.env['HTTP_ACCESS_TOKEN'] || !!request.env.fetch("HTTP_AUTHORIZATION", "").scan(/Bearer/).flatten.first

  end
  def self.len
    64
  end

  def self.iter
    2000
  end
  def self.digest
    OpenSSL::Digest::SHA512.new
  end

  def self.bin_to_hex(s)
    s.each_byte.map { |b| b.to_s(16) }.join
  end

end  