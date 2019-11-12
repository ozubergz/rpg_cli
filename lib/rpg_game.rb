class RpgGame

    attr_reader :character, :winner, :level, :count_win, :enemy

    def run
        # puts path_1
        # path2
        # path3
        # create_username
        intro_game
        create_character
        start_game
        walk_path
        
    end
    
    def intro_game
        puts "Welcome to Escape From The Unholy Point."
        # puts "Create you username."
    end

    # def create_username
    #     username = gets.chomp
    #     @player = Player.create(name: username)
    # end

    def create_character
        puts "Name your character to begin."
        name = gets.chomp
        @character = Character.new(
            name: name,
            hp: 10
        )
        # @character = character
    end

    def start_game
        puts "Press any key to start game"
        @level = 1
        @count_win = 0
        STDIN.getch
    end

    def walk_path
        puts "Press any key to continue along the path"
        STDIN.getch
        enemy_encounter?(roll_dice)
    end

    def roll_dice
        rand(1..7)
    end

    def enemy_encounter?(num)
        prob1 = [1, 2, 3]
        prob2 = [4, 5, 7]
        
        arr = [prob1, prob2].sample
        if (arr.include?(num))
            puts "You have encounter an enemy"
            if(@level == 1)
                @enemy = Enemy.all[0]
                check_winner(player_move, enemy_move)
            elsif (@level == 2)
                @enemy = Enemy.all[1]
                check_winner(player_move, enemy_move)
            elsif (@level == 3)
                @enemy = Enemy.all[2]
                check_winner(player_move, enemy_move)
            end
        else
            puts "You did not encounter any enemy"
            walk_path
        end
    end
    

    def enemy_move
        random_num = rand(1..9)
        move = 'Earthquake' if random_num <= 3
        move = 'Flamethrower' if random_num.between?(4,6)
        move = 'Thunderbolt' if random_num.between?(7,9)
        move
    end

    def player_move
        puts "Choose your magic. Will you melt your opponent into oblivion with
            (1)flamethrower,destroy them with an 
            (2)earthquake, or tear them apart with a powerful
            (3)thunderbolt? Be prepared to face the consequences and enter your magics number"

        magic = ["Flamethrower", "Earthquake", "Thunderbolt"]
        choice = gets.chomp
        num = choice.to_i
        index = num -1
        magic[index]
    end
    
    def battle_wins(winner)
        

        if(winner == "You win!")
            @count_win += 1
        end

        if(@count_win == enemy.counter)
            walk_path
        end

        puts @count_win
        check_winner(player_move, enemy_move)
        
        # if count == 3
        #     walk_path
        # else
        #     puts winner
        #     check_winner(player_move, enemy_move)
        # end
    end

    
    def check_winner(player1_move, player2_move)
        
        @winner = "You win!" if player1_move == 'Earthquake' && player2_move == 'Thunderbolt'
        @winner = "You win!" if player1_move == 'Thunderbolt' && player2_move == 'Flamethrower'
        @winner = "You win!" if player1_move == 'Flamethrower' && player2_move == 'Earthquake'
        @winner = "You lose!" if player2_move == 'Earthquake' && player1_move == 'Thunderbolt'
        @winner = "You lose!" if player2_move == 'Thunderbolt' && player1_move == 'Flamethrower'
        @winner = "You lose!" if player2_move == 'Flamethrower' && player1_move == 'Earthquake'
        @winner = "Nobody" if player1_move == 'Earthquake' && player2_move == 'Earthquake'
        @winner = "Nobody" if player1_move == 'Thunderbolt' && player2_move == 'Thunderbolt'
        @winner = "Nobody" if player1_move == 'Flamethrower' && player2_move == 'Flamethrower'

        battle_wins(@winner)
        
        # break if @winner == "You win!"
        
        
        # puts @winner
        
        
        # if(@winner == "You Win")
        #     @count_win += 1
        # else
        #     check_winner(player1_move, player2_move)
        # end
        
        # if(@count_win == @enemy.counter)
        #     puts "You're at level #{@level}"
        #     @level += 1
        #     walk_path
        # end
    
        
    end

    # def enemy_impact
    #     Enemy.all.map do |enemies|
    #         enemies
    #     end
    # end

    # def enemy_1
    #     Enemy.all[0]
    # end

    # def enemy_2
    #     Enemy.all[1]
    # end

    # def enemy_3
    #     Enemy.all[2]
    # end

end

#[ ]Player should go to path 1 and encounter path 1 enemy. 

#-If player defeats enemy, then player HP + 2, and program
#goes back to the walk path method

#-If player loses to enemy, then player HP - 3, and program goes back to walk path method

#-If its a draw, enemy battle reoccurs until there is a winner

#[ ]If player has already gone down path 1 and defeated enemy 1, player should now go down path 2 and encounter enemy 2.

#-If player defeats enemy, then player HP + 4, and program
#goes back to the walk path method

#-If player loses to enemy, then player HP - 5, and program goes back to walk path method

#-If its a draw, enemy battle reoccurs until there is a winner


#[ ]If player has already gone down path 2 and defeated enemy 2, player should now go down path 3 and encounter enemy 3.

#-If player defeats enemy, then player wins game.

#-If player loses to enemy, then player HP - 7, and program goes back to walk path method

#-If its a draw, enemy battle reoccurs until there is a winner



