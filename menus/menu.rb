require_relative '../constants/constants.rb'

class Menu
    def initialize(path, title) 
        @title = "#{path + ' -> ' unless path == nil}#{title}"
    end

    def draw
        user_input = nil
        menu_option_chosen = 0
        last_menu_option_index = @menu_options.length - 1;

        print(HIDE_CURSOR)

        while(true)
            system(CLEAR_SCREEN)
            puts("#{@title}#{COLORS[RESET]}")

            @menu_options.each_with_index do |menu_option, index|
                puts("#{COLORS[CYAN] unless menu_option_chosen != index}" + menu_option.description + "#{COLORS[RESET]}")
            end

            puts "\n#{@details}#{COLORS[RESET]}"

            user_input = STDIN.getch

            if(user_input == "s")
                if(menu_option_chosen == last_menu_option_index)
                    menu_option_chosen = 0
                else
                    menu_option_chosen += 1
                end
            elsif(user_input == "w")
                if(menu_option_chosen == 0)
                    menu_option_chosen = last_menu_option_index
                else
                    menu_option_chosen -= 1
                end
            elsif(user_input == "\r")
                if(menu_option_chosen == last_menu_option_index)
                    break
                end
                
                @menu_options[menu_option_chosen].action.call
            end
        end
    end
end