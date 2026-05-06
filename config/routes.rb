Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  get "about",  to: "home#about",  as: :about
  get "search", to: "home#search", as: :search

  # Feedback
  get  "give_feedback", to: "contacts#new",    as: :give_feedback
  post "give_feedback", to: "contacts#create"

  # Word flagging
  get "flag_or_r_rated", to: "words#flag_or_r_rated", as: :flag_or_r_rated
  resources :words, only: %i[index show new create edit update destroy]

  # Associations (game core)
  resources :associations, only: [:create]

  # Auth — Registration (passkey)
  get  "register",               to: "registrations#new",       as: :new_registration
  post "registrations/challenge",to: "registrations#challenge", as: :registration_challenge
  post "register",               to: "registrations#create",    as: :registration

  # Auth — Sessions (passkey)
  get    "login",            to: "sessions#new",       as: :new_session
  get    "sessions/challenge",to: "sessions#challenge", as: :session_challenge
  post   "login",            to: "sessions#create",    as: :session
  delete "logout",           to: "sessions#destroy",   as: :destroy_session

  # JSON API for D3 graph
  namespace :api do
    resources :words, only: [] do
      get :associations, on: :member
    end
  end
end
