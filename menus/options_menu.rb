require_relative 'menu'
require_relative 'menu_option'
require_relative 'player_icon_menu'
require_relative 'player_color_menu'
require_relative '../constants/constants.rb'
require_relative '../game_options'

class OptionsMenu < Menu
    def initialize(path)
        @menu_options = [
            MenuOption.new("1. Set player icon", lambda { set_player_icon }),
            MenuOption.new("2. Set player color", lambda { set_player_color }),
            MenuOption.new("3. Back", lambda {})
        ]

        super(path, "GAME OPTIONS")
    end

    def set_player_icon
        player_icon_menu = PlayerIconMenu.new(@title[0..-5])
        player_icon_menu.draw
    end

    def set_player_color
        player_icon_menu = PlayerColorMenu.new(@title[0..-5])
        player_icon_menu.draw
    end
end