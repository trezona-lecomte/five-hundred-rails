class Game < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
  has_many :teams, dependent: :destroy

  validates :teams, length: { maximum: 2 }
end
