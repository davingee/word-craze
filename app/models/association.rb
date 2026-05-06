class Association < ApplicationRecord
  belongs_to :word
  belongs_to :associated_word, class_name: "Word", foreign_key: "association_id"
  has_many :user_associations, dependent: :destroy
end
