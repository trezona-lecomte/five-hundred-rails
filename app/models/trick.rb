class Trick < ActiveRecord::Base
  belongs_to :round
  has_many   :cards
  has_many   :cards # TODO: dependent nullify (all refs become null)
  # NOTE: generally try not to delete data, store the date on which it become 'deleted' etc.

  validates :round, presence: true
  validates :number_in_round, numericality: { greater_than: 0 }
end
