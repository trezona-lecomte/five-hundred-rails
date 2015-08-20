class RoundSerializer < ActiveModel::Serializer
  attributes :id,
             :path,
             :number_in_game,
             :stage,
             :available_bids,
             :odd_team_score,
             :even_team_score


  has_one  :highest_bid
  has_one  :current_trick,  serializer: TrickSerializer
  has_one  :previous_trick, serializer: TrickSerializer
  has_one  :game,           embed: :id
  has_many :tricks,         embed: :ids
  has_many :bids,           key: :placed_bids
  has_many :cards,          key: :current_player_cards
  has_many :players,        serializer: PlayerPreviewSerializer

  #cached
  #delegate :cache_key, to: :object

  def path
    round_path(object)
  end

  def stage
    if object.in_bidding_stage?
      "bidding"
    elsif object.finished?
      "finished"
    else
      "playing"
    end
  end

  def highest_bid
    object.highest_bid
  end

  def available_bids
    object.available_bids
  end

  def cards
    player = object.game.players.where(user: current_user)

    object.unplayed_cards(player)
  end

  def current_trick
    object.current_trick
  end

  def previous_trick
    object.previous_trick
  end

  def players
    object.game.players
  end
end
