class ApplicationController < ActionController::API

  def logged_in?
    !!current_user
  end

  def current_user
    if auth_present?
      user = User.where(:email => auth.first["email"]).select(User.attribute_names - ['salt', 'hash_key'])
      if user
        @current_user ||= user
      end
    end
  end

  def authenticate
    render json: { success: false, msg: "unauthorized"}, status: 401 unless logged_in?
  end

  private

    def token
      Auth.token(request)
    end

    def auth
      Auth.decode(token)
    end

    def auth_present?
      Auth.auth_present?(request)
    end
end
