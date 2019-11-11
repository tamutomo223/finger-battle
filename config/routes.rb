Rails.application.routes.draw do
  
  devise_for :users
  root "groups#index"
  resources :groups, only: [:new,:create,:show, :update]
  get 'groups/:id/turns/new', to: 'turns#new', as: "turns_new"
  post "groups/:id/turns", to: "turns#create", as: "turns_create"
  get "groups/:group_id/turns/:id", to: "turns#show", as: "turns_show"
  get "groups/:group_id/turns/:id/result", to: "turns#result", as: "turns_result"
  
  get "groups/:group_id/turns/:id/attack",to:"attacks#new",as: "attacks_new"
  post "groups/:group_id/turns/:id/attack", to: "attacks#create" ,as: "attacks_create"

  get "groups/:group_id/turns/:id/defence" ,to:"defences#new",as: "defences_new"
  post "groups/:group_id/turns/:id/defence", to: "defences#create",as: "defences_create"
end
