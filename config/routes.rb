Rails.application.routes.draw do
  get 'product_transactions/show'
  get 'product_transactions/insert'
  get 'inventories/show'
  get 'inventories/insert'
  get 'products/show'
  get 'products/insert'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get 'users/login'
  post 'users/login', to: "users#login"
  get 'users/dashboard'
  get 'users/logout', to: "users#logout"
  get 'users/show'
  get 'users/create'
  post 'users/create', to: "users#create"
  get 'users/delete/:id', to: "users#delete", as: "user_delete"
  get 'users/edit/:id', to: "users#edit", as: "user_edit"
  post 'users/update/:id', to: "users#update", as: "user_update"
  

  get 'department/show'
  get 'department/create'
  post 'department/create', to: "department#create"

  get 'role_description/show'
  get 'role_description/create'
  post 'role_description/create', to: "role_description#create"
 
  get "products/show"
  get "products/create_form"
  post "products/create", to: "products#create"

  get "inventories/create_form/:id", to: "inventories#create_form", as: "inventories_create_form"
  post "inventories/create/:id", to: "inventories#create", as: "inventories_create"
  get "inventories/show"

  get "product_transactions/create_form/:id", to: "product_transactions#create_form", as: "product_transactions_create_form"
  post "product_transactions/create/:id", to: "product_transactions#create", as: "product_transactions_create"
  get "product_transactions/show"

  root "users#login"
end
