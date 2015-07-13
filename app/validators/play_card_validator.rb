class PlayCardValidator < ActiveModel::Validator
  def validate(trick)
    # If first trick, did the win the bid?

    # If empty trick, did they win the last one?

    # If not,

    unless
    trick.errors[:base] << "blah"
    trick.errors[:cards] << "blah"
  end
end