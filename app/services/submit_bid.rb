require_dependency 'suits'

class SubmitBid
  attr_reader :round, :player, :error, :bid

  def initialize(round, player)
    @round = round
    @player = player
  end

  def call(tricks, suit)
    round.with_lock do
      add_error("Bidding for this round has finished.") and return unless round.bidding?

      if valid_bid?(tricks, suit)
        @bid = round.bids.create!(tricks: tricks, suit: suit, player: player)
      end
    end
  end

  private

  def add_error(str)
    @error = str
  end

  def valid_bid?(tricks, suit)
    if last_bid = round.bids.most_recent.first
      # binding.pry
      if player.number == round.next_player_number
        if player_already_passed?
          add_error("You've already passed during this round.")
        elsif bid_is_too_low?(tricks, suit, last_bid)
          add_error("Your last bid was too low.") unless bid_is_a_pass?(tricks)
        end
      else
        add_error("It's not your turn to bid.")
      end
    else
      validate_first_player
    end

    error.blank?
  end

  def bid_is_too_low?(tricks, suit, last_bid)
    (tricks < last_bid.tricks) || same_number_of_tricks_and_lower_suit?(tricks, suit, last_bid)
  end

  def bid_is_a_pass?(tricks)
    tricks == 0
  end

  def same_number_of_tricks_and_lower_suit?(tricks, suit, last_bid)
    (tricks == last_bid.tricks) && !(suit == Suits.higher_suit(suit, last_bid.suit))
  end

  def player_already_passed?
    round.bids.passes.where(player: player).present?
  end

  def validate_first_player
    if round.bids.empty? && !(player.number == round.playing_order.first)
      add_error("It's not your turn to bid.")
    end
  end
end
