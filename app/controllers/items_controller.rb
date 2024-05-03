
class ItemsController < ApplicationController
  def index
    diretorio = '/home/angelosouza/Projetos /Leitor-Xml/xmls'
    @xml_files = Dir.glob("#{diretorio}/*.xml").map { |file| File.basename(file) }
  end

  def processar
    # Adiciona uma mensagem de log
    puts "Chamando a função processar"

    # Chama o script Ruby que processa o XML e retorna uma mensagem
    result = `ruby lib/processar_xml.rb`
    puts result
    # Define a mensagem da flash com base na saída do script
    if result.include?("Não há arquivos XML no diretório.")
      flash[:alert] = result
    else
       flash[:notice] = result
    end

    # Redireciona para a página inicial
    redirect_to root_path
  end
end

