
class RpgGame
    # :water #scissor
    # :grass #rock
    # :fire #paper

    def run
        intro_game
        main_menu
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
Welcome to The Unholy Point brave soul. This land is home to dark forces you've yet to encounter. While
they are powerful and sinister, you too have magic on your side. As you encounter these mythical soldiers of the dark lord,
you will either fall to your knees or emerge stronger with more HP and stronger attacks. Engage in battle until a winner 
emerges, and then move foward to advance. If you lose, you may start your jouney again.          
EOF

        pid = fork{ exec "afplay", "musics/188_Barovian_Village.mp3" } 
    end

    def enter_name
        puts "Enter your name."
        username = gets.chomp
        
        if username == ''
            puts "You must enter a name."
            enter_name
        else
            @player = Player.create(name: username)
            create_character
        end
    end

    def create_character
        puts "Name your character to begin."
        name = gets.chomp
        if name == ''
            puts "You must enter a name"
            create_character
        else
            @character = Character.create(name: name, hp: 10, damage: 5)
            @player.character_id = @character.id
            @player.save
            @original_hp = @character.hp
            start_game
        end
    end

    def start_game
        
        @level = 1
        @enemy = Enemy.all[@level - 1]
        @player.enemy_id = @enemy.id
       
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
        $prompt.select("Choose your attack?", %w(fire grass water))
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
        
        puts "HIT! You have damaged the enemy. #{@enemy.name} HP level is #{@enemy.hp}.".colorize(:blue)
        puts "Your HP level is #{@character.hp}".colorize(:blue)
        
        if(@enemy.hp <= 0)
            @player.enemy_id = @enemy.id
            @player.save
            next_level
        else
            fight(player_move, enemy_move)
        end
    end

    def damage_character

        @character.hp -= @enemy.damage

        puts "You have been damaged. #{@enemy.name} HP level is #{@enemy.hp}.".colorize(:red)
        puts "Your HP level is #{@character.hp}".colorize(:red)

        if(@character.hp <= 0)
            puts game_over
        else
            fight(player_move, enemy_move)
        end
    end

    def next_level
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
        ************************************************

        #{@enemy.name} has been defeated! You win!

        You LEVEL UP.
        HP increased by 2
        Damage Points increased by 1

        ************************************************
        ".colorize(:yellow)
    end

    def continue
        @level += 1
        @enemy = Enemy.all[@level - 1]

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

        restart
    end

    def restart
        choice = $prompt.select("Return to menu?", %w(Yes No))
        if choice == "Yes"
            main_menu
        else
            choice = $prompt.select('Do you want to exit the game?', %w(Yes No))
            if choice == 'Yes'
                pid = fork{ exec "killall", "afplay" }
                abort "You have ended the game."
            else
                restart
            end
        end           
    end

    def main_menu
        prompts = $prompt.select("What would you like to do?", %w(Start_Game Records Exit))
        if prompts == "Start_Game"
            enter_name
        elsif prompts == "Records"
            player_records
        else
            choice = $prompt.select('Are you sure you want to exit the game?', %w(Yes No))
            if choice == "Yes"
                pid = fork{ exec "killall", "afplay" }
                abort "You have exited the game."
            else
                main_menu
            end
        end
    end

    def player_records

        record = Player.all.map do |player|
            "Player: #{player.name}, id: #{player.id}, Character: #{player.character.name}, Highest Level: #{player.enemy.id}"
        end

        record << "Go Back"
        
        record_selected = $prompt.select("Delete a record?", record)
        
        if record_selected == "Go Back"
            main_menu
        end
            
        rec = record_selected.match(/\d+/)[0]

        rec.to_i

        choice = $prompt.select("Do you want to delete the record?", %w(Yes No))
        
        if choice == "Yes"
            Player.find(rec).destroy
            puts "Record has been deleted."
            player_records
        else
            player_records
        end
        
    end

end #end of RpgGame







