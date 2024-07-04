require_relative 'menus/main_menu'
require_relative 'constants/constants'
require_relative 'perlin_noise'
require_relative 'fractal_brownian_motion_perlin_noise'

if __FILE__ == $0
    print(HIDE_CURSOR)
    system(CLEAR_SCREEN)

    perlin_noise = PerlinNoise.new()
    fbm_perlin_noise = FractalBrownianMotionPerlinNoise.new()
    map = Array.new(500) { Array.new(500) }

    perlin_noise.generate_perlin_noise(map, 0.2, 42)
    count = 0

    map.each_with_index do |row, i|
        map.each_with_index do |col, j|
            count += 1 if map[i][j] <= 0
        end
    end

    puts count

    perlin_noise.generate_fbm_perlin_noise(map, 1, 0.005, 8)
    count = 0

    map.each_with_index do |row, i|
        map.each_with_index do |col, j|
            count += 1 if map[i][j] <= 0
        end
    end
    puts count


    fbm_perlin_noise.generate_perlin_noise(map, 1, 0.005, 8)
    count = 0

    map.each_with_index do |row, i|
        map.each_with_index do |col, j|
            count += 1 if map[i][j] <= 0
        end
    end
    puts count
    
    # main_menu = MainMenu.new
    # main_menu.draw

    print(SHOW_CURSOR)
end