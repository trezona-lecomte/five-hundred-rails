class Card < ActiveRecord::Base
  has_and_belongs_to_many :hands
end


A slightly more advanced twist on associations is the polymorphic association.
With polymorphic associations, a model can belong to more than one other model, on a single association.
For example, you might have a card model that belongs to either an hand model or a trick model.

Heres how this could be declared

class Card < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end

class Hand < ActiveRecord::Base
  has_many :cards, as: :imageable
end

class Trick < ActiveRecord::Base
  has_many :cards, as: :imageable
end