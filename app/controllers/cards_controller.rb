class CardsController < ApplicationController
  def update
    @card = Card.find(params[:id])

    if @card.update(card_params)
      render template: "games/show", locals: { game: @card.hand.round.game }
    else
      byebug
      render template: "games/show", locals: { game: @card.hand.round.game }
    end
  end

  private

  def card_params
    params.permit(:trick_id)
  end
end
