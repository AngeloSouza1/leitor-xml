class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.datetime :data_emissao
      t.string :razao_social
      t.string :produto
      t.float :quantidade

      t.timestamps
    end
  end
end
