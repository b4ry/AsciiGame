require 'io/console'
require_relative 'menu'
require_relative 'menu_option'
require_relative 'options_menu'
require_relative '../map'
require_relative '../action_processor'
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

        super(nil, "WELCOME TO #{COLORS[RED]}VOID#{COLORS[RESET]}")
    end

    private

    def show_options
        options_menu = OptionsMenu.new("MAIN MENU")
        options_menu.draw()
    end

    def start_game()
        system(CLEAR_SCREEN)
    
        map = Map.new()
        action_processor = ActionProcessor.new(map.map_objects)
        
        player = Player.new()
        map.add_map_object(player)
        
        wall = Wall.new(3, 3)
        map.add_map_object(wall)
    
        wall2 = Wall.new(3, 4)
        map.add_map_object(wall2)
    
        wall4 = Wall.new(3, 5)
        map.add_map_object(wall4)
    
        wall5 = Wall.new(5, 3)
        map.add_map_object(wall5)
    
        wall6 = Wall.new(5, 4)
        map.add_map_object(wall6)
    
        wall3 = Wall.new(5, 5)
        map.add_map_object(wall3)
    
        map.draw_map(player)
    
        begin
            user_input = STDIN.getch()
            action_processor.process_action(user_input, player)
    
            map.draw_map(player)
        end while user_input != "q"

        system(CLEAR_SCREEN)
    end
end