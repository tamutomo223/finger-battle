Rails.application.routes.draw do
  
  devise_for :users
  root "groups#index"
  resources :groups, only: [:new,:create,:show, :update]
  get "users/rank", to: "users#rank"
  resources :users,only:[:show]
  
  get 'groups/:group_id/turns/new', to: 'turns#new', as: "new_turn"
  post "groups/:group_id/turns", to: "turns#create", as: "turns"
  patch "groups/:group_id/turns", to: "turns#update", as: "turn"
  
  get "groups/:group_id/turns/:id/:turn_num", to: "turns#show", as: "turns_show"
  get "groups/:group_id/turns/:id/:turn_num/result", to: "turns#result", as: "turns_result"
  get "groups/:group_id/turns/:id/:turn_num/win", to: "turns#win", as: "turns_win"
  get "groups/:group_id/turns/:id/:turn_num/lose", to: "turns#lose", as: "turns_lose"
  get "groups/:group_id/destroy" ,to: "groups#destroy", as: "groups_destroy"

  get "groups/:group_id/turns/:id/:turn_num/attack",to:"attacks#new",as: "attacks_new"
  post "groups/:group_id/turns/:id/:turn_num/attack", to: "attacks#create" ,as: "attacks"
  get "groups/:group_id/turns/:id/:turn_num/attack/show", to:"attacks#show", as: "attacks_show"

  get "groups/:group_id/turns/:id/:turn_num/defence" ,to:"defences#new",as: "defences_new"
  post "groups/:group_id/turns/:id/:turn_num/defence", to: "defences#create",as: "defences"
  get "groups/:group_id/turns/:id/:turn_num/defence/show", to:"defences#show", as: "defences_show"
end
