require 'jwt'
class Auth::AuthController < ApplicationController
  def register
    email = params['email']
    if email.nil? 
      render :json => { 'success': false, 'msg': 'Email is needed' }
      return
    end

    @user = User.find_by(email: email)
    if !@user.nil?
      # Email has been registered
      render :json => { 'success': false, 'msg': 'The email is registered' }
      return
    end

    first_name = params['first_name']
    if first_name.nil? 
      render :json => { 'success': false, 'msg': 'First name is needed' }
      return
    end

    last_name = params['last_name']
    if last_name.nil? 
      render :json => { 'success': false, 'msg': 'Last name is needed' }
      return
    end
    # All needed params
    pass = params['password']
    if pass.nil? 
      render :json => { 'success': false, 'msg': 'Password is needed' }
      return
    end

    @user = User.new
    @user.first_name = first_name
    @user.last_name = last_name
    @user.email = email
    @user.role_id = 1
    @user.org_id = 1

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
      render :json => { 'success': false, 'msg': 'This email is not registered.' }
      return
    end

    if !@user.validatePassword(password)
      render :json => { 'success': false, 'msg': 'Password is wrong.' }
      return
    end
    exp = Time.now.to_i + 4 * 3600
    token = @user.generateToken(exp)

    render :json => { 'success': true, 'msg': 'Successfully logged in.', token: token }

  end

  def forgetpassword
    render :json => {}
  end
end
