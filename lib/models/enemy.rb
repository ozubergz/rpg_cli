class Enemy < ActiveRecord::Base
    has_many :players
    has_many :characters, through: :players
end