class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      
      t.integer :character_id
      t.integer :enemy_id
      
    end
  end
end
