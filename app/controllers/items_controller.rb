
class ItemsController < ApplicationController
  def index

  end

  def processar
    # Adiciona uma mensagem de log
    puts "Chamando a função processar"

    # Chama o script Ruby que processa o XML e salva no banco de dados
    `ruby lib/processar_xml.rb`

    # Redireciona para a página inicial após o processamento
    redirect_to root_path, notice: "Dados do XML processados e salvos no banco de dados."
  end


end