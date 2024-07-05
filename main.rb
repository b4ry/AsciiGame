require_relative 'helpers/terminal_helper'
require_relative 'menus/main_menu'
require_relative 'constants/constants'

if __FILE__ == $0
    TerminalHelper.hide_cursor()
    TerminalHelper.clear_screen()
    
    main_menu = MainMenu.new
    main_menu.draw

    TerminalHelper.show_cursor()
end