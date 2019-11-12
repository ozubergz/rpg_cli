class CreateCharacters < ActiveRecord::Migration[5.2]
  def down
   remove_column 
  end
  
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :hp
      t.string :thunderbolt #scissor
      t.string :earthquake #rock
      t.string :flamethrower #paper
    end
  end
end
