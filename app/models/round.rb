class Round < ActiveRecord::Base
  has_many :hands, dependent: :destroy
  has_many :tricks, dependent: :destroy
  belongs_to :game

  validates :game, presence: true
end
