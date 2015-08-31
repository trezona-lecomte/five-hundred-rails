class AvailableBidsController < ApplicationController
  before_action :set_round,  only: [:index]

  def index
    bid_generator = GenerateAvailableBids.new(@round)

    if bid_generator.call
      render json: bid_generator.available_bids, each_serializer: AvailableBidSerializer
    else
      render json: { errors: bid_generator.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_round
    @round = Round.preload(:bids, :game).find(params[:round_id])
  end
end
