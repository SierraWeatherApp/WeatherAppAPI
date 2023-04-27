Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get '/weather' => 'weathers#weather_info'
      get '/user' => 'users#info'
      resources :cities, only: %i[show]
      scope :user do
        scope :cities do
          patch '/destroy' => 'users#destroy'
          patch '/change_order' => 'users#order'
          put '/add' => 'users#add'
        end
      end
    end
  end
end
