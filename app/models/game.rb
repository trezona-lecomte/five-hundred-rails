class Game < ActiveRecord::Base
  include ActiveModel::Validations
  has_many :rounds, dependent: :destroy
  has_many :teams, dependent: :destroy

  validates :teams, length: { maximum: 2 }
end
