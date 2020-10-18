Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  resources :users, only: [:show,:index,:edit,:update]
  resources :books do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users do
    member do
     get :followed, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
end
