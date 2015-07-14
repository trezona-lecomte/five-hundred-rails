class PlayCard
  attr_reader :round, :player, :card, :trick

  def initialize(round:, player:)
    @round = round
    @player = player
  end

  def call(card:, trick:)

    # tricks_in_round = Trick.includes(:cards).where(round: trick.round)

    # if trick.cards.empty?
    #   if tricks_in_round.count == 1

    #     # hands.first # TODO actually needs to be the hand belonging to the player who won the bid
    #   else
    #     # previous_trick = tricks_in_round.last(2).first
    #     # previous_trick.winning_card.card_collection
    #   end
    # elsif trick.won?
    #   card.errors[:base] << "This card can't be "
    # else
    #   # hands[trick.cards.count]
    # end


    #   trick.update!(cards: trick.cards << card)

  end
end
