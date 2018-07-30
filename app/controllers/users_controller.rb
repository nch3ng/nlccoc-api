class UsersController < ApplicationController
  before_action :authenticate

  def index
    @users = User.all.select(User.attribute_names - ['salt', 'hash_key'])
    render :json => @users
  end
end
