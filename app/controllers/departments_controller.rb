class DepartmentsController < ApplicationController
  before_action except: [:index]do
    authenticate('org:admin')
  end
end
