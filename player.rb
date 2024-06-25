$global_id = 0

RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
RESET = "\e[0m"

class Player
    Position = Struct.new(:position_x, :position_y)
    
    def initialize
        @position = Position.new(0, 0)
        @id = $global_id
        $global_id += 1
    end

    def get_position
        @position
    end

    def get_id
        @id
    end

    def to_s
        "#{GREEN}|P|#{RESET}"
    end

    def process_action(action)
        if (action == "d" || action == "s")
            move(action)
        end
    end

    def move(direction)
        new_position = Position.new(@position.position_x, @position.position_y);

        if direction == "d"
            new_position.position_x = @position.position_x + 1
        elsif direction == "a"
            new_position.position_x = @position.position_x - 1
        elsif direction == "s"
            new_position.position_y = @position.position_y + 1
        elsif direction == "w"
            new_position.position_y = @position.position_y - 1
        end

        @position = new_position if (
            (new_position.position_x < 10 && new_position.position_x >= 0) && 
            (new_position.position_y < 10 && new_position.position_y >= 0)
        )
    end
end