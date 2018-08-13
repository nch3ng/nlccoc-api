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

    if role.nil? 
      render json: { success: false, msg: "unauthorized"}, status: 401 unless logged_in?
    else
      if auth_present? 
        roles = role.split(':')
        decoded_token = auth[:decoded_token]
        if roles[0] == 'org'
          # role is at role[1]
          if auth[:success]

            if decoded_token['org_role'] != roles[1]
              render json: { success: false, msg: "unauthorized"}, status: 401 
            end
          else
            render json: { success: false, msg: "unauthorized"}, status: 401
          end
        else
          # roles[0] is a role
          if decoded_token['role'] != roles[0]
            render json: { success: false, msg: "unauthorized"}, status: 401
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
