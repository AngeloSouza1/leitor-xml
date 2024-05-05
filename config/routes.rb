Rails.application.routes.draw do
  root 'items#index' # Define a página inicial
  post 'items/processar' # Rota para o método processar do ItemsController
  # Rota para reiniciar a aplicação
  get '/items/reiniciar', to: 'items#reiniciar', as: 'reiniciar_items'
end
