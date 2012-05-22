# -*- encoding : utf-8 -*-
class InsertNewCategory < ActiveRecord::Migration
  def self.up

    Category.all.each do |cat|
      cat.destroy
    end
    
    Category.create(:name => "indumentaria")
    Category.create(:name =>'alimentos')
    Category.create(:name =>'arte')
    Category.create(:name =>'autos')
    Category.create(:name =>'bebes_ninios')
    Category.create(:name =>'belleza')
    Category.create(:name =>'bebidas')
    Category.create(:name =>'celebridades')
    Category.create(:name =>'negocios')
    Category.create(:name =>'deportes')
    Category.create(:name =>'educacion')
    Category.create(:name =>'electronica_gadgets')
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

  def self.down
  end
end
