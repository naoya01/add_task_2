Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update] do
  resource :relationships, only: [:create, :destroy]
  end
  resources :books do
  resource :favorites,only: [:create,:destroy]
  resources :post_comments, only: [:create, :destroy]

  end
end