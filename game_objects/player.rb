require_relative "game_object.rb"

RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
RESET = "\e[0m"

class Player < GameObject
    Position = Struct.new(:row, :col)
    
    def initialize
        super()
        @position = Position.new(1, 1)
        @fov = 5
    end

    def get_position
        @position
    end

    def set_position(position)
        @position = position
    end

    def get_fov
        @fov
    end

    def to_s
        "#{GREEN}😊#{RESET}"
    end  
end