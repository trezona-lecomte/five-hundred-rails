json.(@game, :id)
json.errors(errors)

json.players @game.players do |player|
  json.(player, :id, :handle)
end

json.rounds @game.rounds do |round|
  json.(round, :id)

  json.tricks round.tricks do |trick|
    json.(trick, :id)
  end

  json.hands round.hands do |hand|
    json.(hand, :id, :player_id)

    json.cards hand.cards do |card|
      json.(card, :id, :rank, :suit, :trick_id)
    end
  end
end
