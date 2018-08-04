Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    namespace :auth do
      post 'register', to: 'auth#register'
      post 'login', to: 'auth#login'
      get 'check-state', to: 'auth#check_state'
      get 'forgetpassword', to: 'auth#forgetpassword'
      post 'restpassword', to: 'auth#resetpassword'
    end

    resources :users
    resources :departments
  end
end
