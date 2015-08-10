class CardSerializer < ActiveModel::Serializer
  attributes :id, :rank, :suit, :trick_id, :path

  def path
    card_path(object)
  end
end
