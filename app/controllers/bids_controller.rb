class BidsController < ApplicationController
  before_action :set_round,  only: [:index, :create]
  before_action :set_player, only: [:create]

  def index
    @bids = @round.bids.all
    render :index, status: 200, locals: {errors: []}
  end

  def create
    submit_bid = SubmitBid.new(@round, @player, bid_params[:number_of_tricks], bid_params[:suit])

    submit_bid.call

    @bids = @round.bids.all

    if submit_bid.errors.empty?
      render :index, status: :created, locals: {errors: []}
    else
      render :index, status: :unprocessable_entity, locals: {errors: submit_bid.errors}
    end
  end

  private

  def set_round
    @round = Round.find(bid_params[:round_id])
  end

  def set_player
    @player = Player.find(bid_params[:player_id])
  end

  def bid_params
    params.permit(:round_id, :player_id, :number_of_tricks, :suit)
  end
end
