class UserAssociation < ApplicationRecord
  belongs_to :association
  belongs_to :word
  belongs_to :user, optional: true
end
