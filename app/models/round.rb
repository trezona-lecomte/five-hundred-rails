class Round < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :actions, dependent: :destroy
end
