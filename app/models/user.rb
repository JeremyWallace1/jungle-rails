class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, length: { minimum: 8 }

  def authenticate_with_credentials(email, password)
    if self.email.downcase == email.downcase.strip && self.authenticate(password)
      self
    else
      nil
    end
  end
end
