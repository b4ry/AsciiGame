require_relative 'menu'
require_relative 'menu_option'
require_relative '../constants/constants.rb'
require_relative '../game_options'

class PlayerColorMenu < Menu
    def initialize(path)        
        @menu_options = [
            MenuOption.new("1. #{COLORS[GREEN]}GREEN", lambda { set_player_color(COLORS[GREEN]) }),
            MenuOption.new("2. #{COLORS[RED]}RED", lambda { set_player_color(COLORS[RED]) }),
            MenuOption.new("3. Back", lambda {})
        ]

        super(path, "PLAYER COLOR")

        current_color = GameOptions.get_player_color
        @details = "Current player color: #{current_color}#{COLORS.key(current_color)}"
    end

    def set_player_color(player_color)
        GameOptions.set_player_color(player_color)

        current_color = GameOptions.get_player_color
        @details = "Current player color: #{current_color}#{COLORS.key(current_color)}"
    end
end