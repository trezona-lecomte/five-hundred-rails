class TrickSerializer < ActiveModel::Serializer
  attributes :id, :cards

  #belongs_to :round
  #has_many :cards
end
