class JoinTeam
  def call(user, team)
    if game = team.game

      game.with_lock do
        if team.players.count < Team::MAX_PLAYERS
          player = game.players.create!(user: user,
                                        team: team,
                                        number: "#{team.number}#{team.players.count + 1}")
        else
          team.errors[:base] << "No more than #{Team::MAX_PLAYERS} players can join this team."
        end
      end
    end
  end
end
