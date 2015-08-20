class Player < ActiveRecord::Base
  belongs_to :game, touch: true
  belongs_to :user

  has_many :cards, dependent: :destroy
  has_many :bids,  dependent: :destroy

  # TODO mayble bundle validations on user
  validates :game, :user, presence: true
  validates :user, uniqueness: { scope: :game }
end
