class CardsController < ApplicationController
  def update
    @card = Card.find(params[:id])

    if @card.update(card_params)
      render template: "games/show", locals: { game: @card.round.game }
    else
      render template: "games/show", locals: { game: @card.round.game }
    end
  end

  private

  def card_params
    params.permit(:trick_id)
  end
end
