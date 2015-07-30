json.games @games do |game|
  json.id game.id

  json.players game.players do |player|
    json.(player, :id, :handle)
  end
end
