Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  post 'authenticate', to: 'authentication#authenticate'

  post '/public_graphql', to: 'public_graphql#execute'

  mount ActionCable.server, at: '/cable'
end
