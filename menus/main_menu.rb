require 'io/console'
require_relative 'menu'
require_relative 'menu_option'
require_relative 'options_menu'
require_relative '../map'
require_relative '../game'
require_relative '../game_objects/player'
require_relative '../game_objects/wall'
require_relative '../game_objects/border'
require_relative '../constants/constants.rb'

class MainMenu < Menu
    def initialize
        @menu_options = [
            MenuOption.new("1. Start Game", lambda { start_game }),
            MenuOption.new("2. Options", lambda { show_options }),
            MenuOption.new("3. Exit", lambda {})
        ]

        super(nil, "*** WELCOME TO #{COLORS[RED]}VOID#{COLORS[RESET]} ***")
    end

    private

    def show_options
        options_menu = OptionsMenu.new("*** MAIN MENU")
        options_menu.draw
    end

    def start_game()
        system(CLEAR_SCREEN)
    
        game = Game.new
        map = Map.new(game.get_game_objects)
    
        map_width = map.get_width
        map_height = map.get_height
        
        player = Player.new
        game.add_object(player)
    
        # ADD VERTICAL BORDER
        for x in 0..map_height-1 do
            verticalWallLeft = Border.new(x, 0, true)
            game.add_object(verticalWallLeft)
    
            verticalWallRight = Border.new(x, map_width-1, true)
            game.add_object(verticalWallRight)
        end
    
        # ADD HORIZONTAL BORDER
        for y in 1..map_width-2 do
            horizontalWallUp = Border.new(0, y, false)
            game.add_object(horizontalWallUp)
    
            horizontalWallDown = Border.new(map_height-1, y, false)
            game.add_object(horizontalWallDown)
        end
        
        wall = Wall.new(3, 3)
        game.add_object(wall)
    
        wall2 = Wall.new(3, 4)
        game.add_object(wall2)
    
        wall4 = Wall.new(3, 5)
        game.add_object(wall4)
    
        wall5 = Wall.new(5, 3)
        game.add_object(wall5)
    
        wall6 = Wall.new(5, 4)
        game.add_object(wall6)
    
        wall3 = Wall.new(5, 5)
        game.add_object(wall3)
    
        map.draw_map(player)
    
        begin
            user_input = STDIN.getch
            game.process_action(user_input, player)
    
            map.draw_map(player)
        end while user_input != "q"
    end
end