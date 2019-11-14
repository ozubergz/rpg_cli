class Player < ActiveRecord::Base
    belongs_to :character
    belongs_to :enemy

    def character
        Character.find(self.character_id)
    end

    def enemy
        Enemy.find(self.enemy_id)
    end
    
end