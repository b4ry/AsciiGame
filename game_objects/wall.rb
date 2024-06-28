require_relative "game_object.rb"

class Wall < GameObject
    Position = Struct.new(:row, :col)
    
    def initialize(x, y, vertical)
        super()
        @position = Position.new(x, y)
        @shape = vertical ? " |" : " -"
    end

    def get_position
        @position
    end

    def to_s
        "#{@shape}"
    end
end