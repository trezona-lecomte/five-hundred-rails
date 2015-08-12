class RoundsController < ApplicationController
  before_action :set_round, only: [:show, :update]

  def index
    @rounds = Round.all

    render json: @rounds
  end

  def show
    render json: @round
  end

  def create
    @game = Game.find(round_params[:game_id])

    @round = @game.rounds.new

    deal_cards = DealCards.new(@game, @round)

    if deal_cards.call
      render json: @round, status: :created
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def update
    player = @round.game.players.find_by(user: current_user)
    trick = Trick.find(round_params[:cards][0][:trick_id])
    card  = Card.find(round_params[:cards][0][:id])

    play_card = PlayCard.new(trick, player, card)

    if play_card.call
      render json: play_card.round, serializer: RoundSerializer, status: 200, locals: { errors: [] }
    else
      render json: { errors: play_card.errors }, status: 422
    end
  end

  private

  def set_round
    @round = RoundsDecorator.new(Round.find(params[:id]))
  end

  def round_params
    params.require(:round).permit(cards: [:id, :trick_id])
  end
end
