require 'jwt'
class Auth::AuthController < ApplicationController
  def register
    email = params['email']
    if email.nil? 
      return render :json => { 'success': false, 'msg': 'Email is needed' }
    end

    if !EmailValidator.valid?(email)
      return render :json => { 'success': false, 'msg': 'Bad email format' }
    end

    @user = User.find_by(email: email)
    if !@user.nil?
      # Email has been registered
      return render :json => { 'success': false, 'msg': 'The email is registered' }
    end

    first_name = params['first_name']
    if first_name.nil? 
      return render :json => { 'success': false, 'msg': 'First name is needed' }
    end

    last_name = params['last_name']
    if last_name.nil? 
      return render :json => { 'success': false, 'msg': 'Last name is needed' }
    end
    # All needed params
    pass = params['password']
    if pass.nil? 
      return render :json => { 'success': false, 'msg': 'Password is needed' }
    end

    if pass.length < 8 
      return render :json => { 'success': false, 'msg': 'Password has to be at least 8 characters long' }
    end

    @user = User.new
    @user.first_name = first_name
    @user.last_name = last_name
    @user.email = email

    @user.setPassword(pass)

    if @user.save
      exp = Time.now.to_i + 4 * 3600

      token = @user.generateToken(exp)
      # payload = { exp: exp, id: @user.id, email: @user.email, name: "#{@user.first_name} #{@user.last_name}" }
      # secret = '64a839ead9ea591e1ec8fdfb714fae87b3172832ba79fac2fd4beae5c7e3ca4a95e23a7cd5918d'
      # token = JWT.encode payload, secret, 'HS256'
      # logger.debug(token)

      render json: { success: true, token: token, msg: 'You are successfully registered' }, status: :created, notice: 'user was successfully created.'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def login
    logger.debug params 
    email = params['email']
    password = params['password']

    @user = User.find_by(email: email)

    if @user.nil?
      return render :json => { 'success': false, 'msg': 'This email is not registered' }
    end

    if !@user.validatePassword(password)
      return render :json => { 
        'success': false,
        'msg': 'The password is wrong'
      }
    end
    exp = Time.now.to_i + 4 * 3600
    token = @user.generateToken(exp)

    render :json => { 
      'success': true,
      'msg': 'You are successfully logged in',
      token: token
    }

  end

  def check_state
    token = Auth.token(request)
    msg = User.validateToken(token)
    msg['msg'] = 'You\'re authorized'
    render :json => msg
  end

  def forgetpassword
    render :json => {}
  end
end
