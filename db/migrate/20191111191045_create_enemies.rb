class CreateEnemies < ActiveRecord::Migration[5.2]
  def change
      create_table :enemies do |t|
        t.string :name
        t.integer :hp     
        t.integer :damage #damage on char hp
    end
  end
end
