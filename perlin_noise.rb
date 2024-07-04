class PerlinNoise
    def generate_fbm_perlin_noise(map, amp, freq, octaves_number)
        map.each_with_index do |row, i|
            row.each_with_index do |column, j|
                result = 0.0
                amplitude = amp # bigger amplitude, more height difference
                frequency = freq # bigger frequency, more water

                0.upto(octaves_number-1) do
                    n = amplitude * perlin(i * frequency, j * frequency, 0)
		            result += n
		
		            amplitude *= 0.5
		            frequency *= 2.0
                end
                
                map[i][j] = result
            end
        end
    end

    def generate_perlin_noise(map, scale, seed)
        map.each_with_index do |row, i|
            row.each_with_index do |column, j|
                nx = i * scale;
                ny = j * scale;

                map[i][j] = perlin(nx, ny, seed);
            end
        end
    end

    private

    Vector2 = Struct.new(:x, :y)
    
    def perlin(x, y, seed)
        x0 = x.floor
        x1 = x0 + 1
        y0 = y.floor
        y1 = y0 + 1

        sx = x - x0
        sy = y - y0

        n0 = dot_grid_gradient(x0, y0, x, y, seed)
        n1 = dot_grid_gradient(x1, y0, x, y, seed)
        ix0 = interpolate(n0, n1, sx)

        n0 = dot_grid_gradient(x0, y1, x, y, seed)
        n1 = dot_grid_gradient(x1, y1, x, y, seed)
        ix1 = interpolate(n0, n1, sx)

        value = interpolate(ix0, ix1, sy)

        return value;
    end

    def interpolate(a0, a1, w)
        return a0 if (w < 0)
        return a1 if (w > 1)

        return (a1 - a0) * ((w * (w * 6.0 - 15.0) + 10.0) * w * w * w) + a0
    end

    # could use a permutation table instead
    def random_gradient(ix, iy, seed)
        w = 32
        s = w / 2
        a = ix + seed
        b = iy + seed
        a *= 3284157443
        b ^= a << s | a >> w-s
        b *= 1911520717
        a ^= b << s | b >> w-s
        a *= 2048419325

        random = a * (2 * Math::PI / 0xFFFFFFFF)

        v = Vector2.new(Math.cos(random), Math.sin(random))

        return v;
    end

    def dot_grid_gradient(ix, iy, x, y, seed)
        gradient = random_gradient(ix, iy, seed);

        dx = x - ix
        dy = y - iy

        return (dx * gradient.x + dy * gradient.y)
    end
end