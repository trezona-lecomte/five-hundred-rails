class RoundSerializer < ActiveModel::Serializer
  attributes :id,
             :path,
             :number_in_game,
             :stage,
             :available_bids,
             :odd_team_score,
             :even_team_score

  has_one  :winning_bid
  has_many :bids,                  key: :placed_bids

  has_one  :active_trick,          serializer: TrickSerializer
  has_one  :previous_trick_winner, serializer: TrickWinnerSerializer
  has_many :tricks,                embed: :ids
  has_many :cards,                 key: :current_player_cards
  has_many :players,               serializer: PlayerPreviewSerializer

  #cached
  #delegate :cache_key, to: :object

  def path
    round_path(object)
  end

  def stage
    if object.bidding?
      "bidding"
    elsif object.finished?
      "finished"
    else
      "playing"
    end
  end

  def winning_bid
    object.winning_bid
  end

  def available_bids
    object.available_bids
  end

  def cards
    player = object.game.players.where(user: current_user)
    object.unplayed_cards(player)
  end

  def active_trick
    object.active_trick
  end

  def previous_trick_winner
    object.previous_trick_winner
  end

  def players
    object.game.players
  end
end
