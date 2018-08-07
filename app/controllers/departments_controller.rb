class DepartmentsController < ApplicationController
  # before_action except: [:index]do
  before_action do
    authenticate('org:admin')
  end

  def index
    @depts = Department.all.where(:organization_id => current_user.org_id)
    render :json => { :success => true, :departments => @depts }
  end
end
