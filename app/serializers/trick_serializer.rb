class TrickSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :round
  has_many :cards
end
