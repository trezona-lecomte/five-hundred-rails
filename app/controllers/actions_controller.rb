require 'play_card'

class ActionsController < ApplicationController
  def create
    @round  = Round.find(action_params[:round_id])
    @card   = Card.find(action_params[:card_id])

    play_card = PlayCard.new(@round, @card)

    if play_card.call
      render json: @round, status: :created
    else
      render json: @round.errors, status: :unprocessable_entity
    end
  end

  private

  def action_params
    params.permit(:round_id, :card_id)
  end
end
