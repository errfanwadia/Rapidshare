class User < ActiveRecord::Base
  # attr_accessible :email, :password, :password_confirmation

  attr_accessor :password, :password_confirmation

  before_save :encrypt_password

  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[\w+.]+@[\w\-.]+\.[a-z]+\z/i }

  validates :password, length: { minimum: 6 }, :on => :create
  validates_confirmation_of :password

  has_many :file_uploads

  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    email.downcase!
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end