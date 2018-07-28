class User < ApplicationRecord
  belongs_to :role
  belongs_to :org, class_name: 'Organization'
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true
  before_validation :default_values
  @@len = 64

  def setPassword(password)
    self.salt = bin_to_hex(OpenSSL::Random.random_bytes(@@len))
    self.hash_key = self.generateHash(password, self.salt)
  end

  def validatePassword(password)

    hash_key = self.generateHash(password, self.salt)

    if eql_time_cmp(hash_key, self.hash_key)
      return true
    else
      return false
    end
  end

  def generateHash(password, salt)
    iter = 2000
    key_len = @@len
    digest = OpenSSL::Digest::SHA512.new
    hash = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iter, key_len, digest)

    return bin_to_hex(hash)
  end

  def generateToken(exp)

    payload = { exp: exp, id: self.id, email: self.email, name: "#{self.first_name} #{self.last_name}" }
    secret = '64a839ead9ea591e1ec8fdfb714fae87b3172832ba79fac2fd4beae5c7e3ca4a95e23a7cd5918d'
    token = JWT.encode payload, secret, 'HS256'
    return token
  end

  private def bin_to_hex(s)
    s.each_byte.map { |b| b.to_s(16) }.join
  end

  private def hex_to_bin(s)
    s.scan(/../).map { |x| x.hex.chr }.join
  end

  private def default_values
    self.validated = false
  end

  # Safer way to compare two hash
  private def eql_time_cmp(a, b)
    unless a.length == b.length
      return false
    end
    cmp = b.bytes.to_a
    result = 0
    a.bytes.each_with_index {|c,i|
      result |= c ^ cmp[i]
    }
    result == 0
  end
end
