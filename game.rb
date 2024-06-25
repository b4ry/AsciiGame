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