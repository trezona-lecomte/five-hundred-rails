class CreateGame
  attr_reader :deck_type

  def initialize(deck_type: "standard")
    @deck_type = deck_type
  end

  def call(number_of_teams: 2)
    game = Game.create!(deck_type: deck_type)

    (1..number_of_teams).each do |n|
      game.teams.create!(number: n)
    end

    game
  end
end
