class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_many :players

  validates :username, presence: true

  after_create :update_access_token!

  private

  # TODO: firstly user 'rails token auth', secondly use SecureRandom.uuid
  def update_access_token!
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    save
  end
end
