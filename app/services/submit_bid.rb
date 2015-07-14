require_dependency 'suits'

class SubmitBid
  attr_reader :round, :player, :error, :bid, :tricks, :suit

  def initialize(round, player)
    @round = round
    @player = player
  end

  def call(tricks, suit)
    round.with_lock do
      add_error("Bidding for this round has finished.") and return unless round.bidding?

      @tricks = tricks
      @suit = suit

      if valid_bid?
        @bid = round.bids.create!(tricks: tricks, suit: suit, player: player)
      end
    end
  end

  private

  def add_error(str)
    @error = str
  end

  def valid_bid?
    if last_bid = round.bids.most_recent.first
      if round.next_player?(player)
        if bid_is_too_low?(last_bid)
          add_error("Your last bid was too low.") unless bid_is_a_pass?
        end
      else
        add_error("It's not your turn to bid.")
      end
    else
      validate_first_player
    end

    error.blank?
  end

  def bid_is_too_low?(last_bid)
    (tricks < last_bid.tricks) || same_tricks_lower_suit?(last_bid)
  end

  def bid_is_a_pass?
    tricks == 0
  end

  def same_tricks_lower_suit?(last_bid)
    (tricks == last_bid.tricks) && !(suit == Suits.higher_suit(suit, last_bid.suit))
  end

  def validate_first_player
    if round.bids.empty? && !(player.number == round.playing_order.first)
      add_error("It's not your turn to bid.")
    end
  end
end
