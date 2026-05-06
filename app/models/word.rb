class Word < ApplicationRecord
  has_many :associations, dependent: :destroy
  has_many :user_associations, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 40 }

  before_validation :downcase_name

  scope :playable, -> { where("associations_count > 5 AND flagged < 6") }

  def self.random_playable
    playable.order(Arel.sql("RANDOM()")).first
  end

  private

  def downcase_name
    self.name = name.downcase.strip if name
  end
end
