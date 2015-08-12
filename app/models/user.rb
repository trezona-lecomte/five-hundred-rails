class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_many :players

  after_create :update_access_token!

  validates :username, presence: true

  private

  def update_access_token!
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    save
  end
end
