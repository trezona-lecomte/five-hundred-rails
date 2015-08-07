json.errors(errors)

json.placed_bids @bids do |bid|
  json.(bid, :id, :player_id, :round_id, :number_of_tricks, :suit)
end

round = RoundsDecorator.new(@round)

json.available_bids round.available_bids do |bid|
  json.number_of_tricks(bid[0])
  json.suit(bid[1])
end
