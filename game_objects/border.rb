require_relative "game_object.rb"

class Border < GameObject
    Position = Struct.new(:row, :col)
    
    def initialize(x, y, vertical)
        super(false)
        @position = Position.new(x, y)
        @shape = vertical ? " |" : " -"
    end

    def get_position
        return @position
    end

    def to_s
        return "#{@shape}"
    end
end