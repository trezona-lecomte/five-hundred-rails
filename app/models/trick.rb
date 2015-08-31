class Trick < ActiveRecord::Base
  MAX_CARDS = 4
  belongs_to :round
  has_many   :cards, dependent: :nullify

  validates :round, presence: true
  validates :order_in_round, numericality: { greater_than_or_equal_to: 0 }

  def winning_player
    cards.highest.player
  end

  def active?
    cards_count < MAX_CARDS
  end
  def inactive?
    cards_count == MAX_CARDS
  end

  def self.active
    select(&:active?)
  end

  def self.inactive
    select(&:inactive?)
  end
end
