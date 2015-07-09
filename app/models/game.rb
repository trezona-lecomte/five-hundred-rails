class Game < ActiveRecord::Base
  include ActiveModel::Validations
  has_many :rounds, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_and_belongs_to_many :players

  validates_with GameValidator
end
