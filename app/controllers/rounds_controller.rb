class RoundsController < ApplicationController
  before_action :set_round, only: [:show, :update]

  def index
    @rounds = Round.all

    render json: @rounds
  end

  def show
    render json: @round
  end

  def update
    player = @round.game.players.find_by(user: current_user)
    trick = Trick.find(round_params[:cards][0][:trick_id])
    card  = Card.find(round_params[:cards][0][:id])
    play_card = PlayCard.new(trick, player, card)

    if play_card.call
      score_round = ScoreRound.new(@round)

      if score_round.call
        render json: score_round.round, serializer: RoundSerializer, status: 200, locals: { errors: [] }

        start_next_round
      else
        render json: play_card.round, serializer: RoundSerializer, status: 200, locals: { errors: [] }
      end
    else
      render json: { errors: play_card.errors }, status: 422
    end
  end

  private

  def start_next_round
    start_round = StartRound.new(@round.game)
    start_round.call
  end

  def set_round
    @round = Round.find(params[:id])
  end

  def round_params
    params.require(:round).permit(cards: [:id, :trick_id])
  end
end
