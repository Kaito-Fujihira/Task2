Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  resources :users, only: [:show,:index,:edit,:update] do
  member do
     get :followed, :followers
    end
  end
  resources :books do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]
  get "search" => "searchs#search"
end
