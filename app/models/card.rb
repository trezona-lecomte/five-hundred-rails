class Card < ActiveRecord::Base
  belongs_to :card_collection
  belongs_to :trick
end
