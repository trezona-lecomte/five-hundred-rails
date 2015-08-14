require "rails_helper"

RSpec.describe Trick, type: :model do
  it { should validate_presence_of :round }
end
