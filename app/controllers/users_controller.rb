class UsersController < ApplicationController
  before_action do
    authenticate('org:admin')
  end

  def index
    @users = User.where(:org_id => current_user.org.id).select(User.attribute_names - ['salt', 'hash_key'])
    render :json => @users
  end
  
  def create
    # puts user_params
    # puts params[:email]
    @user = User.new(user_params.merge(email: params[:email], org_id: current_user.org_id, department_id: 1))
    @user.department_id = 1
    if @user.save
      render :json => { :success => true, :user => @user.as_json(:include => [:org_role, :org, :department]) }
    else
      render :json => { :success => false }
    end
  end

  def destroy
    @user = User.where(:id => params[:id], :org_id => current_user.org.id).first
    if @user.destroy
      render :json => { :success => true }
    else
      render :json => { :success => false }
    end
  end

  def update
    @user= User.where(:id => params[:id], :org_id => current_user.org.id).first
    if @user.update(user_params)
      render :json => { :success => true, user: @user.as_json(:include => [:org_role, :org, :department]) }
    else
      render :json => { :success => false }
    end
  end

  def show
    @user = User.where(:id => params[:id], :org_id => current_user.org.id).first
    render :json => @user.as_json(:include => [:org_role, :org, :department])
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :org_role_id, :hired_at, :department_id)
    end
end
