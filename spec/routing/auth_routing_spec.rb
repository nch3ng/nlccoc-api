require 'rails_helper'

RSpec.describe Auth::AuthController, :type => :routing do
  describe 'authentication routing' do
    it 'routes /api/auth/register to auth#register' do
      expect(:post => '/api/auth/register').to route_to('auth/auth#register')
    end 

    it 'routes /api/auth/login to auth#login' do
      expect(:post => '/api/auth/login').to route_to('auth/auth#login')
    end 
  end
end