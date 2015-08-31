class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_many :players, inverse_of: :user, dependent: :destroy

  validates :username, presence: true

  before_create :set_access_token

  private

  # TODO: use 'rails token auth'
  def set_access_token
    self.access_token = SecureRandom.uuid
  end
end
