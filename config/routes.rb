Rails.application.routes.draw do
  apipie

  devise_for :users, except: [:update], controllers: {
      :registrations => 'users/registrations',
      :sessions => 'users/sessions'
  }
end
