Rails.application.routes.draw do
  resources :orders, only: %i[index new create destroy]
  root 'orders#index'
end
