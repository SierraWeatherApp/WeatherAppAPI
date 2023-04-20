Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create] do
        put '/cities/city_order' => 'cities#city_order'
        resources :cities, only: %i[create show index] do 
          delete '/:id', action: :destroy, on: :collection
          #get '/:id', action: :show, on: :collection
        end

      end
    end
  end
end
