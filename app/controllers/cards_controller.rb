class CardsController < ApplicationController
  before_action :set_round,  only: [:index, :update]
  before_action :set_player, only: [:index, :update]
  before_action :set_card,   only: [:update]

  def index
    render json: @player.cards, each_serializer: CardSerializer
  end

  def update
    if !@card
      render json: { errors: ["That card doesn't exist for this round"] }
    else
      play_card = PlayCard.new(
        round: @round,
        player: @player,
        card: @card
      )

      if play_card.call
        render json: play_card.card, serializer: PlayedCardSerializer, status: 200

        if @round.finished?
          score_round = ScoreRound.new(@round)
          score_round.call
          start_next_round
        end
      else
        render json: { errors: play_card.errors }, status: 422
      end
    end
  end

  private

  def start_next_round
    start_round = StartRound.new(game: @round.game)
    start_round.call
  end

  def set_round
    @round = Round.preload(game: [:players]).find(card_params[:round_id])
  end

  def set_player
    @player = @round.game.players.detect { |player| player.user_id == current_user.id }
  end

  def set_card
    @card = @player.cards.detect { |card| card.id == card_params[:id].to_i }
  end

  def card_params
    params.permit(:round_id, :id)
  end
end
