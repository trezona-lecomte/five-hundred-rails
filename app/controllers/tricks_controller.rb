class TricksController < ApplicationController
  before_action :set_trick, only: [:show]

  def show
    render json: @trick, serializer: TrickSerializer
  end

  private

  def set_trick
    @trick = TricksDecorator.new(Trick.find(params[:id]))
  end

  def trick_params
    params.permit(:card_id, :player_id)
  end
end
