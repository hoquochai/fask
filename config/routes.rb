Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => "/admin", as: :rails_admin
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "static_pages#index"

  post "/upload_image", to: "images#upload_image"
  get "/download_file/:name", to: "images#access_file", as: :upload_access_file, name: /.*/

  resources :posts, except: [:edit, :update, :destroy]
  resources :tags, only: :index
  resources :topics
  resources :tag_users, only: :index
  resources :answers, only: :create
  resources :reactions, only: :create
  resources :comments, only: :create
  resources :users
end
