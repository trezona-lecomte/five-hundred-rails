class AvailableBidsController < ApplicationController
  before_action :set_round,  only: [:index]

  def index
    generator = GenerateAvailableBids.new(@round)

    if generator.call
      render json: generator.available_bids, each_serializer: AvailableBidSerializer
    else
      render json: { errors: generator.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_round
    @round = Round.preload(:game).find(params[:round_id])
  end
end
