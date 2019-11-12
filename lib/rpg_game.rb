class RpgGame

    attr_reader :enemy, :battle, :player

    def run
        start_game
        create_character
        choose_path
    end
    
    def start_game
        puts "Welcome to Escape From The Unholy Point."
        puts "Name your character"
    end

    def create_character
        username = gets.chomp
        
        character = Character.create({
            name: username,
            hp: 10,
            thunderbolt: "thunderbolt",
            earthquake: "earthquake",
            flamethrower: "flamethrower"
        })

        @player = character
    end

    def choose_path
        puts "Choose your fate brave soul."
        puts  "Press and enter 1 to go left"
        puts "Press and enter 2 to go right"
        enemy_encounter(gets.chomp)
    end

    def enemy_encounter(user_choice)
        enemy_num = rand(1..2)
        if(user_choice == enemy_num)
            #fighting => method
            puts "fight"
        else
            puts "Freedom awaits you, continue along the path."
            #Describe location, place, little story of what is happening
            #get laid, smoke weed, chill with my bros
            # choose_path
        end
    end




    



end

