require_relative "game_object.rb"

class Wall < GameObject
    Position = Struct.new(:row, :col)
    
    def initialize(x, y, direction)
        super()
        @position = Position.new(x, y)
        @shape = direction == "vertical" ? " |" : " -"
    end

    def get_position
        @position
    end

    def to_s
        "#{@shape}"
    end
end