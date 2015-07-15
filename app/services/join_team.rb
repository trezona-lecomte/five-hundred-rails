class JoinTeam
  attr_reader :user, :error, :player

  def initialize(user)
    @user = user
  end

  def call(team)
    if game = team.game
      game.with_lock do
        if team.players.count < Team::MAX_PLAYERS
          @player = game.players.create!(user: user,
                                        team: team,
                                        table_position: "#{team.number}#{team.players.count + 1}")
        else
          add_error("No more than #{Team::MAX_PLAYERS} players can join this team.")
        end
      end
    end
  end

  private

  def add_error(message)
    @error = message
  end
end
