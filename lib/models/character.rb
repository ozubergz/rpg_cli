class Character < ActiveRecord::Base
    has_many :players
    has_many :enemies, through: :players
end