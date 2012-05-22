# -*- encoding : utf-8 -*-
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name      
    end

    create_table :categories_users, :id => false do |t|
      t.integer :user_id
      t.integer :category_id
    end

    create_table :categories_campaigns, :id => false do |t|
      t.integer :campaign_id
      t.integer :category_id
    end
    
    Category.create(:name =>'Alimentos')
    Category.create(:name =>'Arte')
    Category.create(:name =>'Autos')
    Category.create(:name =>'Bebes & Niños')
    Category.create(:name =>'Belleza')
    Category.create(:name =>'Bebidas')
    Category.create(:name =>'Celebridades')
    Category.create(:name =>'Deals')
    Category.create(:name =>'Deportes')
    Category.create(:name =>'Educacion')
    Category.create(:name =>'Electronica & Gadgets')
    Category.create(:name =>'Empresas')
    Category.create(:name =>'Entretenimento')
    Category.create(:name =>'Familia')
    Category.create(:name =>'Finanzas')
    Category.create(:name =>'Hogar')
    Category.create(:name =>'Jovenes')
    Category.create(:name =>'Juegos')
    Category.create(:name =>'Libros')
    Category.create(:name =>'Marketing')
    Category.create(:name =>'Musica')
    Category.create(:name =>'Politica')
    Category.create(:name =>'Salud')
    Category.create(:name =>'Viajes')
    

  end

  def self.down
    drop_table :categories
    drop_table :categories_campaigns
    drop_table :categories_users
  end
end
