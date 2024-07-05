class LineSegment
    attr_reader :x1, :y1, :x2, :y2, :slope, :intercept
  
    def initialize(x1, y1, x2, y2)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2

      # calculate slope and intercept
      @slope, @intercept = slope_intercept(@x1, @y1, @x2, @y2)
    end
  
    def intersects_line?(other_line)
        # check if lines are parallel
        return false if @slope == other_line.slope
        
        # calculate an intersection point => y = a1 * x + c1 and y = a2 * x + c2
        if @slope == Float::INFINITY
            x = @x1
            y = other_line.slope * x + other_line.intercept
        elsif other_line.slope == Float::INFINITY
            x = other_line.x1
            y = @slope * x + @intercept
        else
            x = (other_line.intercept - @intercept) / (@slope - other_line.slope)
            y = @slope * x + @intercept
        end

        # check if intersection point lies within both line segments
        if within_bounds?(x, y) && other_line.within_bounds?(x, y)
            true
        else
            false
        end
    end

    def line_crosses_grid?(cell_x, cell_y, cell_size)
        top_left = [cell_x, cell_y]
        top_right = [cell_x, cell_y + cell_size]
        bottom_left = [cell_x + cell_size, cell_y]
        bottom_right = [cell_x + cell_size, cell_y + cell_size]

        top_edge = LineSegment.new(top_left[0], top_left[1], top_right[0], top_right[1])
        bottom_edge = LineSegment.new(bottom_left[0], bottom_left[1], bottom_right[0], bottom_right[1])
        left_edge = LineSegment.new(top_left[0], top_left[1], bottom_left[0], bottom_left[1])
        right_edge = LineSegment.new(top_right[0], top_right[1], bottom_right[0], bottom_right[1])
      
        # check intersections with any of the four edges of the cell
        return intersects_line?(top_edge) || intersects_line?(bottom_edge) || intersects_line?(left_edge) || intersects_line?(right_edge)
    end

    def within_bounds?(x, y)
        min_x, max_x = [@x1, @x2].minmax
        min_y, max_y = [@y1, @y2].minmax

        return x.between?(min_x, max_x) && y.between?(min_y, max_y)
    end
  
    private
  
    def slope_intercept(x1, y1, x2, y2)
        if x1 == x2 # vertical lines
            return [Float::INFINITY, x1]
        elsif y1 == y2 # horizontal lines
            return [0, y1]
        else
            # calculate slope from a = (y2 - y1) / (x2 - x1)
            slope = (y2-y1).to_f / (x2 - x1)
            # calculate intercept from y = a * x + c
            intercept = y2 - slope * x2
            
            return [slope, intercept]
        end
    end
end
  