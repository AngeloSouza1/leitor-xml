require 'nokogiri'
require_relative '../config/environment'

def processar_xml
  diretorio = '/home/angelosouza/Projetos /Leitor-Xml/xmls' # Diretório onde os arquivos XML estão localizados

  # Verifica se há arquivos XML no diretório
  xml_files = Dir.glob("#{diretorio}/*.xml")
  if xml_files.empty?
    return "Não há arquivos XML no diretório."
  end

  # Conta o número total de arquivos XML no diretório
  xml_count = xml_files.size

  xmlns = {
    'nfe' => 'http://www.portalfiscal.inf.br/nfe'
  }

  # Se houver XMLs, continue o processamento
  xml_files.each do |xml_file_path|
    xml_file = File.open(xml_file_path)
    xml_doc = Nokogiri::XML(xml_file)
    xml_file.close

    data_emissao_global = xml_doc.at_xpath('//nfe:ide/nfe:dhEmi', xmlns).content
    razao_social_global = xml_doc.at_xpath('//nfe:emit/nfe:xNome', xmlns).content

    xml_doc.xpath('//nfe:det', xmlns).each do |det|
      produto = det.at_xpath('nfe:prod/nfe:xProd', xmlns).content
      quantidade = det.at_xpath('nfe:prod/nfe:qCom', xmlns).content.to_f

      # Criar um novo registro no banco de dados usando o modelo Item
      Item.create!(
        data_emissao: DateTime.parse(data_emissao_global),
        razao_social: razao_social_global,
        produto: produto,
        quantidade: quantidade
      )
    end
  end

  return "Dados dos XMLs processados e salvos no banco de dados. Total de #{xml_count} XMLs encontrados."
end

puts processar_xml
