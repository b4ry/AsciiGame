# implemented according to this: https://rtouti.github.io/graphics/perlin-noise-algorithm
class FractalBrownianMotionPerlinNoise
    def initialize()
        @permutation = make_permutation()
    end

    def generate_perlin_noise(map, amp, freq, octaves_number, seed)
        map.each_with_index do |row, i|
            row.each_with_index do |column, j|
                result = 0.0
                amplitude = amp # bigger amplitude, more height difference
                frequency = freq # bigger frequency, more water
    
                0.upto(octaves_number - 1) do
                    n = amplitude * perlin(i * frequency, j * frequency, seed)
                    result += n
            
                    amplitude *= 0.5
                    frequency *= 2.0
                end
                
                # to move to positive range
                # result += 1.0;
				# result *= 0.5;

                map[i][j] = result
            end
        end
    end

    private

    class Vector2
        attr_reader :x
        attr_reader :y

    	def initialize(x, y)
    		@x = x
    		@y = y
        end

    	def dot(other)
    		return @x * other.x + @y * other.y
        end
    end

    def shuffle(array_to_shuffle)
	    array_to_shuffle.length-1.downto(1) do |current|
		    index = (rand()*(current-1)).round()

		    temp = array_to_shuffle[current]
		    array_to_shuffle[current] = array_to_shuffle[index]
		    array_to_shuffle[index] = temp
        end
    end

    def make_permutation()
	    permutation = []
	
        0.upto(255) do |i|
		    permutation.push(i)
        end

	    shuffle(permutation)
	
        0.upto(255) do |i|
		    permutation.push(permutation[i])
        end
	
	    return permutation
    end

    def get_constant_vector(v)
	    h = v & 3 # % 4

	    if(h == 0)
	    	return Vector2.new(1.0, 1.0)
        elsif(h == 1)
	    	return Vector2.new(-1.0, 1.0)
        elsif(h == 2)
	    	return Vector2.new(-1.0, -1.0)
	    else
	    	return Vector2.new(1.0, -1.0)
        end
    end

    # smooth funtcion
    def fade(t)
	    return ((6 * t - 15) * t + 10) * t * t * t
    end

    # linear interpolation
    def lerp(t, a1, a2)
	    return a1 + t * (a2 - a1)
    end

    def perlin(x, y, seed)
	    x0 = (x.floor + seed) & 255
	    y0 = (y.floor + seed) & 255

	    xf = x - x.floor
	    yf = y - y.floor

        # vectors from corners to the point within a cell
	    from_top_right = Vector2.new(xf - 1.0, yf - 1.0);
	    from_top_left = Vector2.new(xf, yf - 1.0);
	    from_bottom_right = Vector2.new(xf - 1.0, yf);
	    from_bottom_left = Vector2.new(xf, yf);
        
	    value_top_right = @permutation[@permutation[x0+1]+y0+1]
	    value_top_left = @permutation[@permutation[x0]+y0+1]
	    value_bottom_right = @permutation[@permutation[x0+1]+y0]
	    value_bottom_left = @permutation[@permutation[x0]+y0]
        
	    dot_top_right = from_top_right.dot(get_constant_vector(value_top_right))
	    dot_top_left = from_top_left.dot(get_constant_vector(value_top_left))
	    dot_bottom_right = from_bottom_right.dot(get_constant_vector(value_bottom_right))
	    dot_bottom_left = from_bottom_left.dot(get_constant_vector(value_bottom_left))
        
	    u = fade(xf)
	    v = fade(yf)
        
	    return lerp(u, lerp(v, dot_bottom_left, dot_top_left), lerp(v, dot_bottom_right, dot_top_right))
    end
end