require_relative 'menus/main_menu'
require_relative 'constants/constants'
require_relative 'perlin_noise'
require_relative 'fractal_brownian_motion_perlin_noise'

if __FILE__ == $0
    print(HIDE_CURSOR)
    system(CLEAR_SCREEN)
    
    main_menu = MainMenu.new
    main_menu.draw

    print(SHOW_CURSOR)
end