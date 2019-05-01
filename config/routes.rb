Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  post 'authenticate', to: 'authentication#authenticate'
end
