require_relative "game_object.rb"

class Wall < GameObject
    Position = Struct.new(:row, :col)
    
    def initialize(x, y)
        super(true)
        @position = Position.new(x, y)
    end

    def get_position
        return @position
    end

    def to_s
        return " W"
    end
end