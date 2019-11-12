class CreateEnemies < ActiveRecord::Migration[5.2]
  def change
      create_table :enemies do |t|
        t.string :name
        t.integer :hp

        t.string :thunderbolt #scissor
        t.string :earthquake #rock
        t.string :flamethrower #paper
        
        t.integer :damage #damage on char hp
        t.integer :counter #amount of times defeated 
    end
  end
end
