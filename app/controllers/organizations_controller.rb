class OrganizationsController < ApplicationController
  before_action do
    authenticate('admin')
  end
  def index
  end
end
