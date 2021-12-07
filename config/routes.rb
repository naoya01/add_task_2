Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  get 'search', to: 'searches#search'
  devise_for :users
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
  resources :users,only: [:show,:index,:edit,:update] do
    get "search", to: "users#search"
    resource :relationships, only: [:create, :destroy] do
    member do
      get 'follows','followers'
      end
    end
  end
  resources :groups do
    get "join" => "groups#join"
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
    delete  "leave" => "groups#leave"
  end
  resources :books do
    collection do
      get 'search'
    end
    resource :favorites,only: [:create,:destroy]
  resources :post_comments, only: [:create, :destroy]
  end


end