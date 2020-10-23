Rails.application.routes.draw do
  resources :rooms do
    resources :users, shallow: true
  end
  get 'rooms/:room_id/users/bulk', to: 'users#bulk', as: 'bulk_new_room_users'
  post 'rooms/:room_id/users/bulk', to: 'users#create_bulk', as: 'bulk_create_room_users'
  post 'rooms/:room_id/users/invite', to: 'users#invite', as: 'invite_room_users'
  delete 'rooms/:room_id/users/invite', to: 'users#uninvite', as: 'uninvite_room_users'
  get ':token/aanwezig', to: 'main#users'
  get ':token', to: 'main#join', as: 'join_room'
  root 'main#index'
end
