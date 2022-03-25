Rails.application.routes.draw do
  devise_for :users

  root 'hello_world#index'

  post '/search', to: 'twitchers#search'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
