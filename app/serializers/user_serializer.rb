class UserSerializer < ActiveModel::Serializer
  attributes :username, :path

  def path
    user_path(object)
  end
end
