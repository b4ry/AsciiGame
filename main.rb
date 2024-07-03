require_relative 'menus/main_menu'

if __FILE__ == $0
    main_menu = MainMenu.new()
    main_menu.draw
end