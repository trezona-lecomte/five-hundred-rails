class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :allow_cross_origin_requests, if: proc { Rails.env.development? }
  before_filter :authenticate_user_from_token, except: [:preflight, :index, :token]

  def preflight
    render nothing: true
  end

  def index
    render file: "public/index.html"
  end

  def token
    authenticate_with_http_basic do |email, password|
      user = User.find_by(email: email)

      if user && user.password == password
        render json: { token: user.auth_token }
      else
        render json: { error: "Incorrect credentials" }, status: 401
      end
    end
  end

  private

  def authenticate_user_from_token
    unless authenticate_with_http_token { |token, options| User.find_by(auth_token: token) }
      render json: { error: "Bad Token" }, status: 401
    end
  end

  def allow_cross_origin_requests
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'
  end
end
