require_relative 'line_segment.rb'
require_relative 'constants/constants'
require_relative 'helpers/terminal_helper'
require_relative 'perlin_noise'

class Map
    attr_accessor :map_objects
           
    def initialize()
        @columns = 100
        @rows = 100

        @map = Array.new(@rows) { Array.new(@columns) }
        @unaltered_map = Array.new(@rows) { Array.new(@columns) }

        generate_perlin_map()
        @map_objects = {}

        generate_map_borders()
    end

    def draw_map(current_object)
        place_objects()
        draw_object_vision_map(current_object)
    end

    def add_map_object(obj)
        @map_objects[obj.get_id] = obj
    end

    def refresh_previous(row, col) 
        @map[row][col] = @unaltered_map[row][col]
    end
    
    private

    def generate_map_borders
        progress = 0.0

        for x in 0..@rows-1 do
            verticalBorderLeft = Border.new(x, 0, true)
            add_map_object(verticalBorderLeft)
      
            verticalBorderRight = Border.new(x, @columns-1, true)
            add_map_object(verticalBorderRight)

            TerminalHelper.go_to(0, 0)
            progress += 1
            puts("Generating vertical map borders: #{((progress / @rows) * 100).to_i} %")
        end
      
        progress = 0.0

        for y in 1..@columns-2 do
            horizontalBorderUp = Border.new(0, y, false)
            add_map_object(horizontalBorderUp)
      
            horizontalBorderDown = Border.new(@rows-1, y, false)
            add_map_object(horizontalBorderDown)

            TerminalHelper.go_to(0, 0)
            progress += 1
            puts("Generating horizontal map borders: #{((progress / @columns) * 100).to_i} %")
        end

        TerminalHelper.clear_screen()
    end

    def generate_perlin_map
        perlin_noise = PerlinNoise.new()
          
        rand_amp = rand() * 0.15 + 0.95
        rand_freq = rand() * 0.006 + 0.006
        rand_seed = rand(-10000..1000)
  
        perlin_noise.generate_fbm_perlin_noise(@map, rand_amp, rand_freq, 8, rand_seed)
  
        @map.each_with_index do |row, i|
            row.each_with_index do |col, j|
                if(@map[i][j]) < -0.24
                    @map[i][j] = "#{COLORS[DARK_BLUE]} .#{COLORS[RESET]}" # deep water
                elsif(@map[i][j]) < 0.07
                    @map[i][j] = "#{COLORS[BLUE]} .#{COLORS[RESET]}" # water
                elsif(@map[i][j]) < 0.1
                    @map[i][j] = "#{COLORS[YELLOW]} .#{COLORS[RESET]}" # shore
                elsif(@map[i][j]) < 0.15
                    @map[i][j] = "#{COLORS[LIGHT_GREEN]} .#{COLORS[RESET]}" # marsh
                elsif(@map[i][j]) < 0.30
                    @map[i][j] = "#{COLORS[GREEN]} .#{COLORS[RESET]}" # grass
                elsif(@map[i][j]) < 0.42
                    @map[i][j] = "#{COLORS[BROWN]} .#{COLORS[RESET]}" # hills
                elsif(@map[i][j]) < 0.55
                    @map[i][j] = "#{COLORS[WHITE]} .#{COLORS[RESET]}" # mountains
                else
                    @map[i][j] = "#{COLORS[BLACK]} .#{COLORS[RESET]}" # summit
                end
  
                @unaltered_map[i][j] = @map[i][j]
  
                without_space = @map[i][j].sub(" .", ".")
                print(without_space)
            end
  
            puts
        end
  
        TerminalHelper.clear_screen()
    end

    def draw_object_vision_map(current_object)
        TerminalHelper.go_to(0, 0)

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
                if(!(row == current_object_row && col == current_object_col) && obstructed?(row, col, current_object_row, current_object_col))
                    print "  "
                else
                    print @map[row][col]
                end
            end

            print "\n"
        end

        hide_map_outside_fov(current_object_fov, fov_row_min, fov_row_max, fov_col_max, current_object_row, current_object_col)

        TerminalHelper.go_to(0, 30)
        puts("| Current coordinates: x - #{current_object_row}, y - #{current_object_col}, fov (field of vision) - #{current_object_fov} ")
        
        5.times do |row|
            TerminalHelper.go_to(row + 1, 30)
            puts("|")
        end
    end

    def obstructed?(row, col, current_object_row, current_object_col)
        current_object_cell_center = [current_object_row + 0.5, current_object_col + 0.5]

        line_segment_top = LineSegment.new(row, col + 0.5, current_object_cell_center[0], current_object_cell_center[1])
        line_segment_bottom = LineSegment.new(row + 1, col + 0.5, current_object_cell_center[0], current_object_cell_center[1])
        line_segment_left = LineSegment.new(row + 0.5, col, current_object_cell_center[0], current_object_cell_center[1])
        line_segment_right = LineSegment.new(row + 0.5, col + 1, current_object_cell_center[0], current_object_cell_center[1])

        obstructing_in_between_objects = @map_objects.select { |key, value| is_object_in_between_and_obstructing?(value, row, col, current_object_row, current_object_col) }
        
        line_segment_crosses = [false, false, false, false]
        
        obstructing_in_between_objects.each do |key, value|
            obstructing_object = value.get_position
            
            case
            when current_object_col == col
                if current_object_row < row
                    line_segment_crosses[0] |= line_segment_top.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[1] = true
                    line_segment_crosses[2] = true
                    line_segment_crosses[3] = true
                else
                    line_segment_crosses[0] = true
                    line_segment_crosses[1] |= line_segment_bottom.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[2] = true
                    line_segment_crosses[3] = true
                end
            when current_object_col < col
                if current_object_row < row
                    line_segment_crosses[0] |= line_segment_top.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[1] = true
                    line_segment_crosses[2] |= line_segment_left.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[3] = true
                elsif current_object_row > row
                    line_segment_crosses[0] = true
                    line_segment_crosses[1] |= line_segment_bottom.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[2] |= line_segment_left.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[3] = true
                else
                    line_segment_crosses[0] = true
                    line_segment_crosses[1] = true
                    line_segment_crosses[2] |= line_segment_left.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[3] = true
                end
            when current_object_col > col
                if current_object_row < row
                    line_segment_crosses[0] |= line_segment_top.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[1] = true
                    line_segment_crosses[2] = true
                    line_segment_crosses[3] |= line_segment_right.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                elsif current_object_row > row
                    line_segment_crosses[0] = true
                    line_segment_crosses[1] |= line_segment_bottom.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                    line_segment_crosses[2] = true
                    line_segment_crosses[3] |= line_segment_right.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                else
                    line_segment_crosses[0] = true
                    line_segment_crosses[1] = true
                    line_segment_crosses[2] = true
                    line_segment_crosses[3] |= line_segment_right.line_crosses_grid?(obstructing_object.row, obstructing_object.col, 1)
                end
            end            

            if(all_line_segments_cross?(line_segment_crosses))
                return true
            end
        end

        return false
    end

    def is_object_in_between_and_obstructing?(value, row, col, current_object_row, current_object_col)
        min_row, max_row = [current_object_row, row].minmax
        min_col, max_col = [current_object_col, col].minmax

        return value.obstructs? && 
            (
                (value.get_position.row != row || value.get_position.col != col) &&
                (value.get_position.row.between?(min_row, max_row)) &&
                (value.get_position.col.between?(min_col, max_col))
            )
    end

    def hide_map_outside_fov(current_object_fov, fov_row_min, fov_row_max, fov_col_max, current_object_row, current_object_col)
        cursor_col = current_object_fov * 2 + 4

        if((current_object_col - 0) >= current_object_fov) # when the object is further from the left vertical edge by its fov
            cursor_col += current_object_fov * 2 # then just add the fov
        else # when the object can see the left vertical edge,
            cursor_col += (current_object_col - 0) * 2 # then add the difference between the object's position and the edge
        end

        if((@columns - 1) == fov_col_max) # when the object can see the right vertical edge
            cursor_col -= (current_object_fov + current_object_col - fov_col_max) * 2 # remove the distance between the edge and the object from the object's fov
        end

        0.upto(fov_row_max) do |row|
            TerminalHelper.go_to(row + 1, cursor_col)
            print "  "
        end

        cursor_row = 1 + 1 + current_object_fov # rows are not DOUBLED so no need for * 2

        if(fov_row_min == 0) # when the object can see the top edge
            cursor_row += (current_object_row - 0) # add the difference from the edge
        else
            cursor_row += current_object_fov # add the fov
        end

        if((@rows - 1) == fov_row_max) # when the object can see the bottom edge
            cursor_row -= (current_object_fov + current_object_row - fov_row_max) # remove the distance between the edge and the object from the object's fov
        end

        0.upto(cursor_col) do |col|
            TerminalHelper.go_to(cursor_row, col + 1)
            print "  "
        end
    end

    def all_line_segments_cross?(crosses)
        return crosses[0] && crosses[1] && crosses[2] && crosses[3]
    end

    def place_objects
        @map_objects.each do |key, value|
            position = value.get_position
            @map[position.row][position.col] = value.to_s
        end
    end
end