Kuansim::Application.routes.draw do
  resources :events
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root to: 'home#index'


end
