class Map
    def initialize(rows = 10, columns = 10)
        @rows = rows
        @columns = columns
        @map = Array.new(@rows) { Array.new(@columns) }
        @map_objects = []

        def draw_map(current_object)
            clear_screen
            print "\n"

            reset_map
            place_objects
            draw_object_vision_map(current_object)
        end
        
        def draw_object_vision_map(current_object)
            current_object_row = current_object.get_position.row
            current_object_col = current_object.get_position.col
            current_object_fov = current_object.get_fov

            current_object_fov_row_min = current_object_row - current_object_fov;
            current_object_fov_row_max = current_object_row + current_object_fov;
            current_object_fov_col_min = current_object_col - current_object_fov;
            current_object_fov_col_max = current_object_col + current_object_fov;

            fov_row_min = current_object_fov_row_min < 0 ? 0 : current_object_fov_row_min;
            fov_row_max = current_object_fov_row_max >= 9 ? 9 : current_object_fov_row_max;
            fov_col_min = current_object_fov_col_min < 0 ? 0 : current_object_fov_col_min;
            fov_col_max = current_object_fov_col_max >= 9 ? 9 : current_object_fov_col_max;

            for row in fov_row_min..fov_row_max do
                for col in fov_col_min..fov_col_max do
                    print @map[row][col]
                end
                print "\n"
            end

            print "\n"
            puts("Current coordinates: x - #{current_object_row}, y - #{current_object_col}, fov (field of vision) - #{current_object_fov}")
        end
        def reset_map
            @map = Array.new(@rows) { Array.new(@columns, ".") }

            for x in 0..9 do
                @map[x][0] = "|"
                @map[x][9] = "|"
            end

            for y in 1..8 do
                @map[0][y] = "-"
                @map[9][y] = "-"
            end
        end

        def place_objects
            @map_objects.each do |obj|
                position = obj.get_position
                @map[position.row][position.col] = obj.to_s
            end
        end

        def add_object(obj)
            @map_objects[obj.get_id] = obj
            position = obj.get_position
            @map[position.row][position.col] = obj.to_s
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