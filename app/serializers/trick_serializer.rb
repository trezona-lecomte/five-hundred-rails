class TrickSerializer < ActiveModel::Serializer
  attributes :id, :path

  has_many :cards, serializer: PlayedCardSerializer

  def path
    trick_path(object)
  end
end
