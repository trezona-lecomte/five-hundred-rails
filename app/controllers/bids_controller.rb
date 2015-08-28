class BidsController < ApplicationController
  before_action :set_round,  only: [:index, :create]
  before_action :set_player, only: [:create]

  def create
    bid = Bid.new(
      round: @round,
      player: @player,
      pass: bid_params[:pass],
      number_of_tricks: bid_params[:number_of_tricks],
      suit: bid_params[:suit]
    )

    if bid.save
      render json: bid.round, serializer: RoundSerializer, status: :created, locals: { errors: [] }
    else
      render json: { errors: bid.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_round
    @round = Round.find(bid_params[:round_id])
  end

  def set_player
    @player = @round.game.players.find_by(user: current_user)
  end

  def bid_params
    params.permit(:round_id, :pass, :number_of_tricks, :suit)
  end
end
