class Trick < ActiveRecord::Base
  MAX_CARDS = 4
  belongs_to :round
  has_many   :cards, dependent: :nullify

  validates :round, presence: true
  validates :number_in_round, numericality: { greater_than: 0 }

  scope :active,           -> { where("cards_count < ?", MAX_CARDS) }
  scope :inactive,         -> { where(cards_count: MAX_CARDS) }
  scope :in_playing_order, -> { order(number_in_round: :asc) }

  def winning_player
    cards.highest.player
  end
end
