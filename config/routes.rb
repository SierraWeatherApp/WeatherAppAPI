Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get '/weather' => 'weathers#weather_info'
      get '/user' => 'users#info'
      patch '/user' => 'users#update'
      resources :cities, only: %i[show]
      scope :user do
        scope :questions do
          get 'all' => 'users#all'
          patch 'answer' => 'users#answers'
        end
        scope :cities do
          patch '/destroy' => 'users#destroy'
          patch '/change_order' => 'users#order'
          put '/add' => 'users#add'
        end
        scope :cloth do
          patch 'change_cloth' => 'users#cloth'
        end
      end
    end
  end
end
