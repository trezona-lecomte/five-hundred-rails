class Round < ActiveRecord::Base
  MAX_TRICKS = 10

  belongs_to :game
  has_many   :tricks, dependent: :destroy
  has_many   :hands, -> { where.not(player_id: nil) }, class_name: "CardCollection"
  has_one    :kitty, -> { where(player_id:  nil) }, class_name: "CardCollection"
  has_many   :bids, dependent: :destroy, after_add: :progress_to_playing_stage

  serialize :playing_order, Array
  enum stage: [:bidding, :playing]


  def progress_to_playing_stage(bid)
    playing! if bids.passes.count >= (hands.count - 1)
  end

  # TODO: this doesn't belong here!
  def next_player?(player)
    bids.passes.where(player: player).empty? && player.number == next_player_number
  end

  def next_player_number
    index_of_last_player = playing_order.index(Bid.most_recent.first.player.number)

    if index_of_last_player >= (playing_order.length - 1)
      playing_order[0]
    else
      playing_order[index_of_last_player + 1]
    end
  end

  #   if (index_of_last_player + 1) == playing_order.length
  #     index_of_next_player = 0

  #     next_player = game.players.where(number: playing_order[index_of_next_player]).first

  #     until next_player.bids.passes.empty?
  #       index_of_next_player += 1
  #       next_player = game.players.where(number: playing_order[index_of_next_player]).first
  #     end
  #       playing_order[index_of_next_player]
  #   else
  #     playing_order[index_of_last_player + 1]
  #   end
  # end
end
