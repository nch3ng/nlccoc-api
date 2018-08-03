class UsersController < ApplicationController
  before_action do
    authenticate('org:admin')
  end

  def index
    @users = User.where(:org_id => current_user.org.id).select(User.attribute_names - ['salt', 'hash_key'])
    render :json => @users
  end
  
  def create
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
  end

  def show
    @user = User.where(:id => params[:id], :org_id => current_user.org.id).first
    render :json => @user
  end

  private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name)
    end
end
