require_relative 'menu'
require_relative 'menu_option'
require_relative '../constants/constants.rb'
require_relative '../game_options'

class PlayerIconMenu < Menu
    def initialize(path)        
        @menu_options = [
            MenuOption.new("1. @", lambda { set_player_icon("@") }),
            MenuOption.new("2. #", lambda { set_player_icon("#") }),
            MenuOption.new("3. Back", lambda {})
        ]

        super(path, "PLAYER ICON")
        @details = "Current player icon: #{GameOptions.get_player_icon}"
    end

    def set_player_icon(player_icon)
        GameOptions.set_player_icon(player_icon)
        @details = "Current player icon: #{GameOptions.get_player_icon}"
    end
end