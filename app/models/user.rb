class User < ApplicationRecord
  belongs_to :department, class_name: 'Department', optional: true
  belongs_to :role
  belongs_to :org_role, class_name: 'Role'
  belongs_to :org, class_name: 'Organization'
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true
  before_validation :default_values

  def setPassword(password)
    self.salt = Auth.salt
    self.hash_key = self.generateHash(password, self.salt)
  end

  def validatePassword(password)
    hash_key = self.generateHash(password, self.salt)
    return eql_time_cmp(hash_key, self.hash_key)
  end

  def generateHash(password, salt)
    Auth.issueHash(password, salt)
  end

  def generateToken(exp)
    payload = { 
      exp: exp, 
      id: self.id, 
      email: self.email, 
      name: "#{self.first_name} #{self.last_name}",
      role: self.role.name,
      org_role: self.org_role.name }
    token = Auth.issue(payload)
    return token
  end

  def self.validateToken(token)
    Auth.decode(token)
  end

  private def default_values
    role = Role.find_by(:name => 'normal')
    if self.role.nil?
      self.role = role
    end

    if self.org_role.nil?
      self.org_role = role
    end

    self.org_id = 1
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
