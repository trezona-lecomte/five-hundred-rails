json.(@game, :id)

json.players @game.players do |player|
  json.(player, :id, :handle)
end

json.rounds @game.rounds do |round|
  round = RoundsDecorator.new(round)

  json.(round, :id)

  if round.bidding?
    json.stage("bidding")
  elsif round.playing?
    json.stage("playing")
  else
    json.stage("finished")
  end

  if round.winning_bid
    json.winning_bid(round.winning_bid, :id, :player_id, :number_of_tricks, :suit)
  else
    json.winning_bid(nil)
  end

  json.bids round.bids do |bid|
    json.(bid, :id, :player_id, :number_of_tricks, :suit)
  end

  json.tricks round.tricks do |trick|
    json.(trick, :id)
  end

  json.hands round.hands.each do |player, hand|
    json.player(player, :id)

    json.cards hand.each do |card|
      json.(card, :id, :trick_id, :player_id, :rank, :suit)
    end
  end
end
