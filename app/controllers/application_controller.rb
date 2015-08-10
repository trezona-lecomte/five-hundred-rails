class ApplicationController < ActionController::API
  # include ActionController::HttpAuthentication::Basic::ControllerMethods
  # include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :allow_cross_origin_requests, if: proc { Rails.env.development? }
  # before_filter :authenticate_user_from_token, except: [:preflight, :index, :token]

  respond_to :json

  def preflight
    render nothing: true
  end

  def index
    render file: "public/index.html"
  end

  def authenticate_user_from_token
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token(auth_token)
    else
      authentication_error
    end
  end

  # def token
  #   authenticate_with_http_basic do |email, password|
  #     user = User.find_by(email: email)

  #     if user && user.password == password
  #       render json: { token: user.auth_token }
  #     else
  #       render json: { error: "Incorrect credentials" }, status: 401
  #     end
  #   end
  # end

  private

  def authenticate_with_auth_token(token)
    unless token.include?(":")
      authentication_error
      return
    end

    user_id = token.split(":").first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, token)
      sign_in(user, store: false)
    else
      authentication_error
    end
  end

  def authentication_error
    render json: { error: "Bad Token" }, status: 401
  end

  # def authenticate_user_from_token
  #   unless authenticate_with_http_token { |token, options| User.find_by(auth_token: token) }
  #     render json: { error: "Bad Token" }, status: 401
  #   end
  # end

  def allow_cross_origin_requests
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'
  end
end
