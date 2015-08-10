class ApplicationController < ActionController::API
  before_action :allow_cross_origin_requests, if: proc { Rails.env.development? }
  before_action :authenticate_user_from_token!

  respond_to :json

  def preflight
    render nothing: true
  end

  def index
    render file: "public/index.html"
  end

  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authentication_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    unless auth_token.include?(':')
      authentication_error
      return
    end

    user_id = auth_token.split(':').first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in user, store: false
    else
      authentication_error
    end
  end

  def authentication_error
    render json: {error: 'unauthorized'}, status: 401
  end

  def allow_cross_origin_requests
     headers['Access-Control-Allow-Origin'] = '*'
     headers['Access-Control-Request-Method'] = '*'
     headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
     headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
     headers['Access-Control-Max-Age'] = '1728000'
  end
end
