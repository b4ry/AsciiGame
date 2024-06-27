$global_id = 0

RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
RESET = "\e[0m"

class Player
    Position = Struct.new(:row, :col)
    
    def initialize
        @position = Position.new(1, 1)
        @id = $global_id
        @fov = 1

        $global_id += 1
    end

    def get_position
        @position
    end

    def get_id
        @id
    end

    def get_fov
        @fov
    end

    def to_s
        "#{GREEN}P#{RESET}"
    end

    def process_action(action)
        if (action == "d" || action == "s")
            move(action)
        end
    end

    def move(direction)
        new_position = Position.new(@position.row, @position.col);

        if direction == "d"
            new_position.col = @position.col + 1
        elsif direction == "a"
            new_position.col = @position.col - 1
        elsif direction == "s"
            new_position.row = @position.row + 1
        elsif direction == "w"
            new_position.row = @position.row - 1
        end

        @position = new_position if (
            (new_position.row < 10 && new_position.row >= 0) && 
            (new_position.col < 10 && new_position.col >= 0)
        )
    end
end