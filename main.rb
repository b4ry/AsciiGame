require_relative 'menus/main_menu'
require_relative 'constants/constants'
require_relative 'perlin_noise'
require_relative 'fractal_brownian_motion_perlin_noise'

if __FILE__ == $0
    print(HIDE_CURSOR)
    system(CLEAR_SCREEN)

    # map = Array.new(225) { Array.new(225) }

    # rand_amp = rand() * 0.15 + 0.95
    # rand_freq = rand() * 0.006 + 0.006
    # rand_seed = rand(-10000..1000)

    # puts("GENERATED FOR: #{rand_amp}:#{rand_freq}:#{rand_seed}\n")

    # perlin_noise = PerlinNoise.new()
    # fbm_perlin_noise = FractalBrownianMotionPerlinNoise.new()

    # perlin_noise.generate_fbm_perlin_noise(map, rand_amp, rand_freq, 8, rand_seed)

    # map.each_with_index do |row, i|
    #     map.each_with_index do |col, j|
    #         if(map[i][j]) < -0.24
    #             map[i][j] = "\e[48;5;18m.#{COLORS[RESET]}" # deep water
    #         elsif(map[i][j]) < 0.07
    #             map[i][j] = "\e[44m.#{COLORS[RESET]}" # water
    #         elsif(map[i][j]) < 0.1
    #             map[i][j] = "\e[43m.#{COLORS[RESET]}" # shore
    #         elsif(map[i][j]) < 0.15
    #             map[i][j] = "\e[42m.#{COLORS[RESET]}" # marsh
    #         elsif(map[i][j]) < 0.30
    #             map[i][j] = "\e[48;5;70m.#{COLORS[RESET]}" # grass
    #         elsif(map[i][j]) < 0.42
    #             map[i][j] = "\e[48;5;94m.#{COLORS[RESET]}" # hills
    #         elsif(map[i][j]) < 0.55
    #             map[i][j] = "\e[47m.#{COLORS[RESET]}" # mountains
    #         else
    #             map[i][j] = "\e[48;5;235m.#{COLORS[RESET]}" # summit
    #         end

    #         print (map[i][j])
    #     end

    #     puts
    # end
 
    # puts
    # puts
    # puts
    # puts
    # fbm_perlin_noise.generate_perlin_noise(map, rand_amp, rand_freq, 8, rand_seed)

    # map.each_with_index do |row, i|
    #     map.each_with_index do |col, j|
    #         if(map[i][j]) < -0.24
    #             map[i][j] = "\e[48;5;18m.#{COLORS[RESET]}" # deep water
    #         elsif(map[i][j]) < 0.07
    #             map[i][j] = "\e[44m.#{COLORS[RESET]}" # water
    #         elsif(map[i][j]) < 0.1
    #             map[i][j] = "\e[43m.#{COLORS[RESET]}" # shore
    #         elsif(map[i][j]) < 0.15
    #             map[i][j] = "\e[42m.#{COLORS[RESET]}" # marsh
    #         elsif(map[i][j]) < 0.30
    #             map[i][j] = "\e[48;5;70m.#{COLORS[RESET]}" # grass
    #         elsif(map[i][j]) < 0.42
    #             map[i][j] = "\e[48;5;94m.#{COLORS[RESET]}" # hills
    #         elsif(map[i][j]) < 0.55
    #             map[i][j] = "\e[47m.#{COLORS[RESET]}" # mountains
    #         else
    #             map[i][j] = "\e[48;5;235m.#{COLORS[RESET]}" # summit
    #         end

    #         print (map[i][j])
    #     end

    #     puts
    # end
    # puts
    # puts
    # puts
    # puts
    
    main_menu = MainMenu.new
    main_menu.draw

    print(SHOW_CURSOR)
end