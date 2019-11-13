
class RpgGame
    # :water #scissor
    # :grass #rock
    # :fire #paper

    def run
        intro_game
        main_menu
        enter_name
        create_character
        start_game
    end
    
    def intro_game
        puts <<-'EOF'
        ,--,  ,.-.
        ,                   \,       '-,-`,'-.' | ._
       /|           \    ,   |\         }  )/  / `-,',
       [ '          |\  /|   | |        /  \|  |/`  ,`
       | |       ,.`  `,` `, | |  _,...(   (      _',
        \  \  __ ,-` `  ,  , `/ |,'      Y     (   \_L\
         \  \_\,``,   ` , ,  /  |         )         _,/
         \  '  `  ,_ _`_,-,<._.<        /         /
          ', `>.,`  `  `   ,., |_      |         /
            \/`  `,   `   ,`  | /__,.-`    _,   `\
        -,-..\  _  \  `  /  ,  / `._) _,-\`       \
         \_,,.) /\    ` /  / ) (-,, ``    ,        |
        ,` )  | \_\       '-`  |  `(               \
       /  /```(   , --, ,' \   |`<`    ,            |
      /  /_,--`\   <\  V /> ,` )<_/)  | \      _____)
,-, ,`   `   (_,\ \    |   /) / __/  /   `----`
(-, \           ) \ ('_.-._)/ /,`    /
| /  `          `/ \\ V   V, /`     /
,--\(        ,     <_/`\\     ||      /
(   ,``-     \/|         \-A.A-`|     /
,>,_ )_,..(    )\          -,,_-`  _--`
(_ \|`   _,/_  /  \_            ,--`
\( `   <.,../`     `-.._   _,-`
`                      ```               
EOF


        pid = fork{ exec "afplay", "musics/188_Barovian_Village.mp3" } 
    end

    def enter_name
        puts "Enter your name."
        username = gets.chomp
        @player = Player.create(name: username)
    end

    def create_character
        puts "Name your character to begin."
        name = gets.chomp
        @character = Character.create(name: name, hp: 10, damage: 5)
        @player.character_id = @character.id
        @player.save
        @original_hp = @character.hp
    end

    def start_game
        puts "Press any key to start game"
        @level = 1
        @enemy = Enemy.all[@level - 1]
        STDIN.getch
        puts "
        ===================================================

                Level #{@level}. #{@enemy.name}.

        ===================================================
        ".colorize(:yellow)
        fight(player_move, enemy_move)
    end

    def enemy_move
        random_num = rand(1..9)
        move = 'water' if random_num <= 3
        move = 'grass' if random_num.between?(4,6)
        move = 'fire' if random_num.between?(7,9)
        move
    end

    def player_move
        $prompt.select("Choose your destiny?", %w(fire grass water))
    end

    def fight(player1, player2)
        
        fight_result = "win" if player1 == 'water' && player2 == 'fire'
        fight_result = "win" if player1 == 'grass' && player2 == 'water'
        fight_result = "win" if player1 == 'fire' && player2 == 'grass'

        fight_result = "lose" if player2 == 'water' && player1 == 'fire'
        fight_result = "lose" if player2 == 'grass' && player1 == 'water'
        fight_result = "lose" if player2 == 'fire' && player1 == 'grass'

        fight_result = "tie" if player1 == 'water' && player2 == 'water'
        fight_result = "tie" if player1 == 'grass' && player2 == 'grass'
        fight_result = "tie" if player1 == 'fire' && player2 == 'fire'
        
        check_win(fight_result)
    end

    def check_win(result)
        if(result == "win")
            damage_enemy
        elsif(result == "lose")
            damage_character
        elsif(result == 'tie')
            puts "It's tie!. No damage has occured."
            fight(player_move, enemy_move)
        end
    end
    
    def damage_enemy
        @enemy.hp -= @character.damage
        
        puts "HIT! You have damaged the enemy. #{@enemy.name} HP level is #{@enemy.hp}."
        puts "Your HP level is #{@character.hp}"
        
        if(@enemy.hp <= 0)
            puts "
            ----------------------------------------------
            #{@enemy.name} have been defeated! You win!
            ----------------------------------------------
            ".colorize(:red)
            @player.enemy_id = @enemy.id
            @player.save
            next_level
        else
            fight(player_move, enemy_move)
        end
    end

    def damage_character

        @character.hp -= @enemy.damage

        puts "You have been damaged. #{@enemy.name} HP level is #{@enemy.hp}."
        puts "Your HP level is #{@character.hp}"

        if(@character.hp <= 0)
            puts game_over
        else
            fight(player_move, enemy_move)
        end
    end

    def next_level
        @level += 1
        @enemy = Enemy.all[@level - 1]
        if(@level > 5)
            win_game
        else
            increase_stats
            continue
        end
    end

    def increase_stats
        health = @original_hp += 2
        @character.hp = health
        @character.damage += 1

        puts "
        ******************************
        You LEVEL UP.
        HP increased by 2
        Damage Points increased by 1
        ******************************
        ".colorize(:yellow)
    end

    def continue
        puts "Press any key to continue on to the next level."
        STDIN.getch

        puts "
        ===================================================

                Level #{@level}. #{@enemy.name}.

        ===================================================
        ".colorize(:yellow)

        fight(player_move, enemy_move)
    end

    def win_game
        puts "
        ================================================

        CONGRATULATIONS! YOU'VE ESCAPE THE UNHOLY POINT!

        ================================================
        ".colorize(:yellow)
        pid = fork{ exec "killall", "afplay" }
    end

    def game_over
        puts "
        +++++++++++++++++++++++++
        YOU HAVE DIED! GAME OVER!
        +++++++++++++++++++++++++
        ".colorize(:red)
        pid = fork{ exec "killall", "afplay" }
    end

    def main_menu
        prompts = $prompt.select("What would you like to do?", %w(PlayGame PlayerRecords))
        puts prompts
        if prompts == "PlayGame"
            start_game
        else 
            player_records
        end
    end

    def player_records
        record = []

        Player.all.each do |player|
            Character.all.each do |character|
                Enemy.all.each do |enemy|
                    if(player.character_id == character.id && player.enemy_id == enemy.id)
                        record << "Player: #{player.name}, id: #{player.id} Character: #{character.name} Highest level: #{enemy.id}"
                    end
                end
            end
        end

        record.each do |item|
            item
        end
        
        record_selected = $prompt.select("Delete a record?", record)

        #The following code must delete the record index selected by the player

        rec = record_selected.match(/\d+/)[0]

        rec.to_i

        Player.find(rec).destroy
    end

end #end of RpgGame

#Return player name with
#1. Name 
#2. Level
#3. HP







