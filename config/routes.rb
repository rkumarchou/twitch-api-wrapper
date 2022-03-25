Rails.application.routes.draw do
  root 'hello_world#index'

  post '/search', to: 'twitchers#search'
end
