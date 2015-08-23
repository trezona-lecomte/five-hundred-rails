class PlayerSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :handle, :order_in_game

  has_one :user
  has_many :cards
end
