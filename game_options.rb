require_relative 'constants/constants'

class GameOptions
    def self.get_player_icon
        return @player_icon ||= '@'
    end

    def self.set_player_icon(player_icon)
        @player_icon = player_icon
    end

    def self.get_player_color
        return @player_color ||= COLORS[GREEN]
    end

    def self.set_player_color(player_color)
        @player_color = player_color
    end
end