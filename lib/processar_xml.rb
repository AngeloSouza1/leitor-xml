require 'nokogiri'
require 'json'

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

  items = []

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

      # Adiciona os dados do item ao array de items
      items << {
        data_emissao: data_emissao_global,
        razao_social: razao_social_global,
        produto: produto,
        quantidade: quantidade
      }
    end
    end

            # Gera o nome do arquivo JSON com base na data atual e na quantidade de XMLs processados
            json_file_name = "/home/angelosouza/Projetos /Leitor-Xml/jsons/#{Time.now.strftime("%Y-%m-%d")}_#{xml_count}_xmls.json"


            # Gera o arquivo JSON com os últimos dados XML convertidos
            File.open(json_file_name, 'w') do |file|
              file.write(JSON.pretty_generate(items))
            end



  return "Total de #{xml_count} XMLs encontrados. Dados dos XMLs processados e salvos no banco de dados e salvos no arquivo JSON: #{json_file_name}"
end

puts processar_xml
