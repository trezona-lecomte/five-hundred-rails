class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_many :players # TODO dependent destroy

  validates :username, presence: true # TODO not null in db.

  # Do this in before - after create/save callbacks are icky.
  after_create :update_access_token!

  private

  # TODO: firstly user 'rails token auth', secondly use SecureRandom.uuid
  def update_access_token!
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    save # TODO should have bang
  end
end
