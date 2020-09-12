Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :user_sessions, only: [:create] do
    collection do
      delete :destroy_session
    end
  end
  resources :appointments, only: [:create, :index]
end
