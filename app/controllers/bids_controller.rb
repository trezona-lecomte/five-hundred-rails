class BidsController < ApplicationController
  before_action :set_round,  only: [:index, :create]
  before_action :set_player, only: [:create]

  def create
    submit_bid = SubmitBid.new(@round, @player, bid_params[:number_of_tricks], bid_params[:suit])

    submit_bid.call

    @bids = @round.bids.all

    if submit_bid.errors.empty?
      render json: submit_bid.round, serializer: RoundSerializer, status: :created, locals: { errors: [] }
    else
      render json: { errors: submit_bid.errors }, status: :unprocessable_entity
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
    params.permit(:round_id, :number_of_tricks, :suit)
  end
end
