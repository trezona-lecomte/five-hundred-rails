class SubmitBid
  def self.call(round, player, number, suit)
    round.with_lock do
      bids = round.actions.bids.all

      allowed_to_play = false

      # if number > bids.

      if bids.present?
        if player.number == round.next_player_number
          allowed_to_play = true
        end
      else
        if player.number == round.playing_order.first
          allowed_to_play = true
        end
      end

      if allowed_to_play
        round.actions.create!(action_type: Action::BID,
                              action_value: "#{number}, #{suit}",
                              player: player)
      else
        player.errors[:actions] << "It's not your turn to bid!"
      end
    end
  end
end
