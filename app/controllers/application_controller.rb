class ApplicationController < ActionController::API

  def logged_in?
    !!current_user
  end

  def current_user
    if auth_present?
      if auth[:success]
        decoded_token = auth[:decoded_token]
        user = User.where(:email => decoded_token["email"]).select(User.attribute_names - ['salt', 'hash_key']).first
        if user
          @current_user ||= user
        end
      end
    end
  end

  def authenticate(role = nil)
    logger.debug(role)
    if role.nil? 
      render json: { success: false, msg: "unauthorized"}, status: 401 unless logged_in?
    else
      if auth_present? 
        roles = role.split(':')
        if roles[0] == 'org'
          if auth['success']
            decoded_token = auth['decoded_token']
            # puts decoded_token
            if decoded_token['org_role'] != role
              render json: { success: false, msg: "unauthorized"}, status: 401 unless logged_in?
            end
          else
            render json: { success: false, msg: "unauthorized"}, status: 401 unless logged_in?
          end
        end
      else
        render json: { success: false, msg: "unauthorized"}, status: 401 unless logged_in?
      end
    end
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
