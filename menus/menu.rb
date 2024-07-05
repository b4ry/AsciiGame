require_relative '../helpers/terminal_helper'
require_relative '../constants/constants.rb'

class Menu
    def initialize(path, title) 
        @title = "#{path + ' / ' unless path == nil}#{title}"
    end

    def draw
        user_input = nil
        menu_option_chosen = 0
        last_menu_option_index = @menu_options.length - 1;

        loop do
            TerminalHelper.display_text_at("#{@title}#{COLORS[RESET]}", 0, 0)

            @menu_options.each_with_index do |menu_option, index|
                TerminalHelper.display_text_at("#{COLORS[CYAN] unless menu_option_chosen != index}" + menu_option.description + "#{COLORS[RESET]}", index + 2, 0)
            end

            TerminalHelper.display_text_at("#{@details}#{COLORS[RESET]}", @menu_options.length + 3, 0)

            user_input = STDIN.getch

            if(user_input == DOWN)
                if(menu_option_chosen == last_menu_option_index)
                    menu_option_chosen = 0
                else
                    menu_option_chosen += 1
                end
            elsif(user_input == UP)
                if(menu_option_chosen == 0)
                    menu_option_chosen = last_menu_option_index
                else
                    menu_option_chosen -= 1
                end
            elsif(user_input == ENTER)
                if(menu_option_chosen == last_menu_option_index)
                    break
                end
                
                @menu_options[menu_option_chosen].action.call
            end
        end
    end
end