class Trick < ActiveRecord::Base
  MAX_CARDS = 4
  belongs_to :round
  has_many   :cards # TODO: dependent nullify (all refs become null)
  # NOTE: generally try not to delete data, store the date on which it become 'deleted' etc.

  validates :round, presence: true
  validates :number_in_round, numericality: { greater_than: 0 }

  scope :active,           -> { where("cards_count < ?", MAX_CARDS) }
  scope :inactive,         -> { where(cards_count: MAX_CARDS) }
  scope :in_playing_order, -> { order(number_in_round: :asc) }

  def winning_player
    cards.highest.player
  end
end
