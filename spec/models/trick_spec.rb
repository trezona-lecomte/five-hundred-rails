require "rails_helper"

RSpec.describe Trick, type: :model do
  it { should validate_presence_of :round }
  it { should validate_numericality_of(:order_in_round).is_greater_than_or_equal_to(0) }
end
