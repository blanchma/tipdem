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

    ActiveRecord::Base.transaction do
      Category.create(:name => "indumentaria")
      Category.create(:name =>'alimentos')
      Category.create(:name =>'arte')
      Category.create(:name =>'autos')
      Category.create(:name =>'bebes')
      Category.create(:name =>'belleza')
      Category.create(:name =>'bebidas')
      Category.create(:name =>'celebridades')
      Category.create(:name =>'negocios')
      Category.create(:name =>'deportes')
      Category.create(:name =>'educacion')
      Category.create(:name =>'electronica')
      Category.create(:name =>'empresas')
      Category.create(:name =>'entretenimento')
      Category.create(:name =>'familia')
      Category.create(:name =>'finanzas')
      Category.create(:name =>'hogar')
      Category.create(:name =>'jovenes')
      Category.create(:name =>'juegos')
      Category.create(:name =>'libros')
      Category.create(:name =>'marketing')
      Category.create(:name =>'musica')
      Category.create(:name =>'politica')
      Category.create(:name =>'salud')
      Category.create(:name =>'viajes')
    end
  end

  def self.down
    drop_table :categories
    drop_table :categories_campaigns
    drop_table :categories_users
  end
end
