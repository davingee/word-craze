class Contact < ApplicationRecord
  validates :comments, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
