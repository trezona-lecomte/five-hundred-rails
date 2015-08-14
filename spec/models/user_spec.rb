require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should validate_uniqueness_of :email }
  it { should validate_length_of(:password).is_at_least(8) }

  describe "access token" do
    subject { user.access_token }

    context "before the record has been saved" do
      let(:user) { User.new(valid_user_attributes) }

      it { is_expected.to be_nil }
    end

    context "after the record has been saved" do
      let(:user) { User.create!(valid_user_attributes) }

      it { is_expected.to include(user.id.to_s) }
    end
  end

  def valid_user_attributes
    {
      email:    Faker::Internet.email,
      password: Faker::Internet.password,
      username: Faker::Internet.user_name
    }
  end
end
