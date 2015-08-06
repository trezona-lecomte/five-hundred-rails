json.(@game, :id)
json.errors(errors)

json.players @game.players do |player|
  json.(player, :id, :handle)
end

json.rounds @game.rounds do |round|
  round = RoundsDecorator.new(round)

  json.(round, :id)

  json.tricks round.tricks do |trick|
    json.(trick, :id)
  end

  json.hands round.hands.each do |player, hand|
    json.player(player, :id)

    json.cards hand.each do |card|
      json.(card, :id, :trick_id, :rank, :suit)
    end
  end
end
