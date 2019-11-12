class CreateBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :battles do |t|
      t.integer :character_id
      t.integer :enemy_id
      
    end
  end
end
