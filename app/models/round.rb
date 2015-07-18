class Round < ActiveRecord::Base
  MAX_TRICKS = 10

  belongs_to :game
  has_many :tricks, dependent: :destroy
  has_many :bids, dependent: :destroy, after_add: :progress_to_playing_stage
  has_many :hands, -> { where.not(player_id: nil) }, class_name: "CardCollection",
                                                     dependent: :destroy
  has_one :kitty, -> { where(player_id:  nil) }, class_name: "CardCollection",
                                                 dependent: :destroy

  validates_presence_of :playing_order

  enum stage: [:bidding, :playing]
  serialize :playing_order, Array

  def progress_to_playing_stage(bid)
    playing! if bids.passes.count >= (hands.count - 1)
  end

  def next_player?(player)
    if bidding?
      bids.passes.where(player: player).empty? && (player.table_position == next_table_position)
    elsif playing?
      player.table_position == next_table_position
    end
  end

  def next_table_position
    if bidding?
      index_of_last_player = playing_order.index(Bid.most_recent.first.player.table_position)

      if index_of_last_player >= (playing_order.length - 1)
        playing_order[0]
      else
        playing_order[index_of_last_player + 1]
      end
    elsif playing?
      index_of_last_player = playing
  end
end
