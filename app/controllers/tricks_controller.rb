class TricksController < ApplicationController
  before_action :set_trick, only: [:show]

  def show
    render json: @trick
  end

  def update
    @trick = Trick.find(params[:id])
    @player = Player.find(trick_params[:player_id])
    @card = Card.find(trick_params[:card_id])

    play_card = PlayCard.new(@trick, @player, @card)

    if play_card.call
      render json: @trick, status: :updated
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  private

  def set_trick
    @trick = Trick.find(params[:id])
  end

  def trick_params
    params.permit(:card_id, :player_id)
  end
end
