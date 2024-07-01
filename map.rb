require_relative "line_segment.rb"

class Map
    def initialize(game_objects)        
        begin
            puts("Provide map width (min 3): ")
            @columns = gets.to_i
        end while @columns < 3

        begin
            puts("Provide map height (min 3): ")
            @rows = gets.to_i
        end while @rows < 3

        @map = Array.new(@rows) { Array.new(@columns) }
        @game_objects = game_objects
    end
    
    def get_width
        return @columns
    end

    def get_height
        return @rows
    end

    def draw_map(current_object)
        clear_screen
        print "\n"

        reset_map
        place_objects
        draw_object_vision_map(current_object)
    end
    
    private 

    def draw_object_vision_map(current_object)
        current_object_row = current_object.get_position.row
        current_object_col = current_object.get_position.col
        current_object_fov = current_object.get_fov

        current_object_fov_row_min = current_object_row - current_object_fov;
        current_object_fov_row_max = current_object_row + current_object_fov;
        current_object_fov_col_min = current_object_col - current_object_fov;
        current_object_fov_col_max = current_object_col + current_object_fov;

        fov_row_min = current_object_fov_row_min < 0 ? 0 : current_object_fov_row_min;
        fov_row_max = current_object_fov_row_max < @rows ? current_object_fov_row_max : @rows-1;
        fov_col_min = current_object_fov_col_min < 0 ? 0 : current_object_fov_col_min;
        fov_col_max = current_object_fov_col_max < @columns ? current_object_fov_col_max : @columns-1;

        for row in fov_row_min..fov_row_max do
            for col in fov_col_min..fov_col_max do
                # a line between a player and the current cell
                line_segment = LineSegment.new(row+0.5, col+0.5, current_object_row+0.5, current_object_col+0.5)
                crosses = false
                obstructing_objects = @game_objects.select { |key, value| value.obstructs? && (value.get_position.row != row || value.get_position.col != col) }

                # checks intersection with all game objects
                obstructing_objects.each do |key, value|
                    game_object_position = value.get_position
                    
                    crosses = line_segment.line_crosses_grid?(game_object_position.row, game_object_position.col, 1)

                    if(crosses)
                        break
                    end
                end

                if(!crosses)
                    print @map[row][col]
                else
                    print "  "
                end
            end

            print "\n"
        end

        print "\n"
        puts("Current coordinates: x - #{current_object_row}, y - #{current_object_col}, fov (field of vision) - #{current_object_fov}")
    end
    
    def reset_map
        @map = Array.new(@rows) { Array.new(@columns, " .") }
    end

    def place_objects
        @game_objects.each do |key, value|
            position = value.get_position
            @map[position.row][position.col] = value.to_s
        end
    end

    def clear_screen
        if RUBY_PLATFORM =~ /win32|win64|mingw/
          system("cls")  # Windows
        else
          print "\e[2J\e[f"  # Unix-like
        end
    end
end