Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  get 'search', to: 'searches#search'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update] do
  resource :relationships, only: [:create, :destroy] do
    member do
      get 'follows','followers'
    end
  end
end
  resources :books do
  resource :favorites,only: [:create,:destroy]
  resources :post_comments, only: [:create, :destroy]

  end
end