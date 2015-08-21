class UserSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :username, :email
end
