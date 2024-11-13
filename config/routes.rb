Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'location', to: 'locations#fetch_location'
      get 'bands/search', to: 'bands#search'
    end
  end
end
