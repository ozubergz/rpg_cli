class Player < ActiveRecord::Base
    belongs_to :character
    belongs_to :enemy
end