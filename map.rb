require_relative 'line_segment.rb'
require_relative 'constants/constants'

class Map
    attr_accessor :map_objects
           
    def initialize()
        @columns = 100
        @rows = 100

        @map = Array.new(@rows) { Array.new(@columns) }
        @map_objects = {}

        for x in 0..@rows-1 do
            verticalBorderLeft = Border.new(x, 0, true)
            add_map_object(verticalBorderLeft)
    
            verticalBorderRight = Border.new(x, @columns-1, true)
            add_map_object(verticalBorderRight)
        end
    
        for y in 1..@columns-2 do
            horizontalBorderUp = Border.new(0, y, false)
            add_map_object(horizontalBorderUp)
    
            horizontalBorderDown = Border.new(@rows-1, y, false)
            add_map_object(horizontalBorderDown)
        end
    end

    def draw_map(current_object)
        clear_screen
        print("\n")

        reset_map
        place_objects
        draw_object_vision_map(current_object)
    end

    def add_map_object(obj)
        @map_objects[obj.get_id] = obj
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
                # a line between current object and the current cell
                current_object_cell_center = [current_object_row + 0.5, current_object_col + 0.5]
                line_segment_top = LineSegment.new(row, col + 0.5, current_object_cell_center[0], current_object_cell_center[1])
                line_segment_bottom = LineSegment.new(row + 1, col + 0.5, current_object_cell_center[0], current_object_cell_center[1])
                line_segment_left = LineSegment.new(row + 0.5, col, current_object_cell_center[0], current_object_cell_center[1])
                line_segment_right = LineSegment.new(row + 0.5, col + 1, current_object_cell_center[0], current_object_cell_center[1])

                # if any of the line segment edge is obstructed
                line_segment_crosses = [false, false, false, false]
                
                # checks intersection with all obstructing map objects
                obstructing_objects = @map_objects.select { |key, value| value.obstructs? && (value.get_position.row != row || value.get_position.col != col) }

                obstructing_objects.each do |key, value|
                    obstructing_object = value.get_position
                    
                    line_segment_crosses[0] |= line_segment_top.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[1] |= line_segment_bottom.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[2] |= line_segment_left.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[3] |= line_segment_right.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)

                    if(all_line_segments_cross(line_segment_crosses))
                        break
                    end
                end

                if(!(all_line_segments_cross(line_segment_crosses)))
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

    def all_line_segments_cross(crosses)
        return crosses[0] && crosses[1] && crosses[2] && crosses[3]
    end

    def reset_map
        @map = Array.new(@rows) { Array.new(@columns, " .") }
    end

    def place_objects
        @map_objects.each do |key, value|
            position = value.get_position
            @map[position.row][position.col] = value.to_s
        end
    end

    def clear_screen
        if RUBY_PLATFORM =~ /win32|win64|mingw/
          system(CLEAR_SCREEN)  # Windows
        else
          print("\e[2J\e[f")  # Unix-like
        end
    end
end