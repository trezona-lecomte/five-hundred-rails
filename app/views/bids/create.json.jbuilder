json.(@round, :id)
json.errors(errors)

json.bids @bids do |bid|
  json(bid, :id, :player_id, :round_id, :number_of_tricks, :suit)
end
