class BidsController < ApplicationController
  before_action :set_round,  only: [:create]
  before_action :set_player, only: [:create]

  def index
    @round = Round.preload(:game, bids: [:player]).find(bid_params[:round_id])

    render json: @round.bids
  end

  def create
    bid = Bid.new(
      round: @round,
      player: @player,
      pass: bid_params[:pass],
      number_of_tricks: bid_params[:number_of_tricks],
      suit: bid_params[:suit]
    )

    if bid.save
      render json: bid, serializer: BidSerializer, status: :created, locals: { errors: [] }
    else
      render json: { errors: bid.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_round
    @round = Round.preload(:game).find(bid_params[:round_id])
  end

  def set_player
    @player = @round.game.players.detect { |player| player.user_id == current_user.id }
  end

  def bid_params
    params.permit(:round_id, :pass, :number_of_tricks, :suit)
  end
end
