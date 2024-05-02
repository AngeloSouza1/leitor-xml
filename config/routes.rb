# config/routes.rb
Rails.application.routes.draw do
  root 'items#index' # Define a página inicial
   post 'items/processar' # Rota para o método processar do ItemsController


end
