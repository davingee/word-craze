class User < ApplicationRecord
  has_many :webauthn_credentials, dependent: :destroy
  has_many :user_associations, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { minimum: 2, maximum: 30 }

  before_validation :normalize_email

  def admin?
    role == "admin"
  end

  private

  def normalize_email
    self.email = email.downcase.strip if email
  end
end
