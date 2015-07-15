class Round < ActiveRecord::Base
  MAX_TRICKS = 10
  enum stage: [:bidding, :playing]

  belongs_to :game
  has_many   :tricks, dependent: :destroy
  has_many   :hands, -> { where.not(player_id: nil) }, class_name: "CardCollection"
  has_one    :kitty, -> { where(player_id:  nil) }, class_name: "CardCollection"
  has_many   :bids, dependent: :destroy, after_add: :progress_to_playing_stage

  serialize :playing_order, Array

  validates_presence_of :playing_order

  def progress_to_playing_stage(bid)
    playing! if bids.passes.count >= (hands.count - 1)
  end

  def next_player?(player)
    if bidding?
      bids.passes.where(player: player).empty? && (player.table_position == next_table_position)
    elsif playing?

    end
  end

  def next_table_position
    index_of_last_player = playing_order.index(Bid.most_recent.first.player.table_position)

    if index_of_last_player >= (playing_order.length - 1)
      playing_order[0]
    else
      playing_order[index_of_last_player + 1]
    end
  end
end
