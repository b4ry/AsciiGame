require_relative 'menus/main_menu'
require_relative 'constants/constants'

if __FILE__ == $0
    main_menu = MainMenu.new
    main_menu.draw

    print(SHOW_CURSOR)
end