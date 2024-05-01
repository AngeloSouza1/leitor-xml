require 'nokogiri'
require_relative '../config/environment'

# Função para extrair os dados de cada item do XML e salvar no banco de dados
def processar_xml(xml_doc)
  # Definir o namespace do XML
  xmlns = {
    'nfe' => 'http://www.portalfiscal.inf.br/nfe'
  }

  # Iterar sobre cada item (det) no XML e extrair os dados
  xml_doc.xpath('//nfe:det', xmlns).each do |det|
    data_emissao = xml_doc.at_xpath('//nfe:ide/nfe:dhEmi', xmlns).content
    razao_social = xml_doc.at_xpath('//nfe:emit/nfe:xNome', xmlns).content
    produto = det.at_xpath('nfe:prod/nfe:xProd', xmlns).content
    quantidade = det.at_xpath('nfe:prod/nfe:qCom', xmlns).content.to_f

    # Criar um novo registro no banco de dados usando o modelo Item
    Item.create!(
      data_emissao: DateTime.parse(data_emissao),
      razao_social: razao_social,
      produto: produto,
      quantidade: quantidade
    )
  end
end

# Carregar o XML
xml_file = File.open('/home/angelosouza/Projetos /Leitor-Xml/xmls/NFe_15_20231201_10_000000013.xml')


xml_doc = Nokogiri::XML(xml_file)
xml_file.close

# Processar o XML e salvar os dados no banco de dados
processar_xml(xml_doc)

puts "Dados do XML processados e salvos no banco de dados."
