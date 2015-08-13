require "rails_helper"

RSpec.describe User, type: :model do
  let(:username) { Faker::Internet.user_name }
  let(:email)    { Faker::Internet.email }
  let(:password) { Faker::Internet.password }

  describe "validations" do
    subject(:create_user) { User.create!(username: username, email: email, password: password) }

    context "when given valid attributes" do
      it { is_expected.to be_valid }
    end

    context "when no username is provided" do
      let(:username) { nil }

      it "raises a validation error" do
        expect { create_user }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when no email is provided" do
      let(:email) { nil }

      it "raises a validation error" do
        expect { create_user }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
