require_relative "game_object.rb"
require_relative "../constants/constants.rb"

class Player < GameObject
    Position = Struct.new(:row, :col)
    
    def initialize
        super(false)
        @position = Position.new(1, 1)
        @fov = 5
    end

    def get_position
        return @position
    end

    def set_position(position)
        @position = position
    end

    def get_fov
        return @fov
    end

    def to_s
        return "#{GREEN} @#{RESET}"
    end  
end