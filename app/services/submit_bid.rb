class SubmitBid
  # TODO: For the love of god, no!
  def self.call(round, player, tricks, suit)
    round.with_lock do
      if round.bidding?
        bids = round.bids.all

        if bids.empty?
          if player.number == round.playing_order.first
            player_turn = true
            bid_high_enough = true
          end
        else
          if player.number == round.next_player_number
            player_turn = true

            last_bid = bids.most_recent_bid

            if tricks == 0
              bid_high_enough = true
            elsif tricks > last_bid.tricks
              bid_high_enough = true
            elsif tricks == last_bid.tricks
              if suit == Bid.higher_suit(suit, last_bid.suit)
                bid_high_enough = true
              end
            end
          end
        end

        if player_turn && bid_high_enough
          round.bids.create!(tricks: tricks, suit: suit, player: player)
        elsif !player_turn
          player.errors[:bids] << "It's not your turn to bid."
        else
          player.errors[:bids] << "Your last bid was too low."
        end
      else
        player.errors[:bids] << "Bidding for this round has finished."
      end
    end
  end
end
