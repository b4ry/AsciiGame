require 'io/console'

$global_id = 0

RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
RESET = "\e[0m"

class Game
    def initialize(rows = 10, columns = 10)
        @rows = rows
        @columns = columns
        @map = Array.new(@rows) { Array.new(@columns, "|_|") }
        @map_objects = []

        def draw_map
            clear_screen
            print "\n"

            # reset map
            @map = Array.new(@rows) { Array.new(@columns, "|_|") }

            # draw objects on the map 
            @map_objects.each do |obj|
                position = obj.get_position
                @map[position.position_y][position.position_x] = obj.to_s
            end

            # print map
            @rows.times do |row|
                @columns.times do |col|
                    print @map[row][col]
                end
                print "\n"
            end

            print "\n"
        end
        
        def add_object(obj)
            @map_objects[obj.get_id] = obj
        end

        def clear_screen
            if RUBY_PLATFORM =~ /win32|win64|mingw/
              system("cls")  # Windows
            else
              print "\e[2J\e[f"  # Unix-like
            end
        end
    end
    
end

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

if __FILE__ == $0
    game = Game.new
    player = Player.new
    
    game.add_object(player)
    game.draw_map

    begin
        user_input = STDIN.getch
        player.move(user_input)

        game.draw_map
    end while user_input != "q"
end