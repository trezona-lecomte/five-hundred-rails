class DealRound
  attr_reader :game, :deck, :playing_order, :round

  def initialize(game:)
    @game = game
  end

  def call(playing_order: [11, 21, 12, 22])
    @playing_order = playing_order
    @deck = freshly_shuffled_deck
    @round = new_round

    create_empty_kitty && create_empty_hands

    kitty_size.times { deal_card(round.kitty) }

    round.hands.each do |hand|
      hand_size.times { deal_card(hand) }
    end
  end

  private

  def freshly_shuffled_deck
    BuildDeck.new(game.deck_type).call.shuffle!
  end

  def new_round
    game.rounds.create!(playing_order: playing_order)
  end

  def create_empty_kitty
    round.kitty = CardCollection.create!
  end

  def create_empty_hands
    game.players.each do |player|
      round.hands.create!(player: player)
    end
  end

  def deal_card(collection)
    collection.playing_cards.create!(card: deck.pop)
  end

  def kitty_size
    Decks.send("#{game.deck_type.downcase}_kitty_size")
  end

  def hand_size
    Decks.send("#{game.deck_type.downcase}_hand_size")
  end
end
