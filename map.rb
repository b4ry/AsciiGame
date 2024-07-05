require_relative 'line_segment.rb'
require_relative 'constants/constants'
require_relative 'helpers/terminal_helper'
require_relative 'perlin_noise'

class Map
    attr_accessor :map_objects
           
    def initialize()
        @columns = 225
        @rows = 225

        @map = Array.new(@rows) { Array.new(@columns) }
        @unaltered_map = Array.new(@rows) { Array.new(@columns) }

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

        TerminalHelper.clear_line(fov_row_max + 2, 0)

        cursor_col = current_object_col <= 4 ? (current_object_fov_col_max+2)*2 : 24

        0.upto(fov_row_max) do |row|
            TerminalHelper.go_to(row + 1, cursor_col)
            print "  "
        end

        TerminalHelper.go_to(0, 30)
        puts("| Current coordinates: x - #{current_object_row}, y - #{current_object_col}, fov (field of vision) - #{current_object_fov} ")
        
        5.times do |row|
            TerminalHelper.go_to(row + 1, 30)
            puts("|")
        end
    end

    def all_line_segments_cross(crosses)
        return crosses[0] && crosses[1] && crosses[2] && crosses[3]
    end

    def place_objects
        @map_objects.each do |key, value|
            position = value.get_position
            @map[position.row][position.col] = value.to_s
        end
    end
end