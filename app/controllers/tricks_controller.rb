class TricksController < ApplicationController
  before_action :set_round, only: [:index]
  before_action :set_trick, only: [:show]

  def index
    render json: @round.tricks, each_serializer: TrickPreviewSerializer
  end

  def show
    render json: @trick, serializer: TrickSerializer
  end

  private

  def set_round
    @round = Round.preload(:tricks).find(params[:round_id])
  end

  def set_trick
    @trick = Trick.find(params[:id])
  end
end
