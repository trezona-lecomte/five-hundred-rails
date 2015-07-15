require_dependency 'decks'

Decks.standard_deck.each do |card|
  Card.create!(number: card[:number], suit: card[:suit])
end
