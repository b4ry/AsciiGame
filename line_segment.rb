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
  
    def intersection(other_line)
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
            intercept = y2 - a * x2
            
            return [slope, intercept]
        end
    end
  
    def within_bounds?(x, y)
        min_x, max_x = [@x1, @x2].minmax
        min_y, max_y = [@y1, @y2].minmax

        return x.between?(min_x, max_x) && y.between?(min_y, max_y)
    end
end
  