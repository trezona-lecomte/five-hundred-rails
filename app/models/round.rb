class Round < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  has_many :tricks, dependent: :destroy
end
