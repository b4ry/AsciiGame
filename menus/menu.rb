require_relative '../constants/constants.rb'

class Menu
    def draw
        user_input = nil
        menu_option_chosen = 0
        last_menu_option_index = @menu_options.length - 1;

        print(HIDE_CURSOR)

        while(true)
            system("cls")
            puts("#{@title}")

            @menu_options.each_with_index do |menu_option, index|
                puts("#{CYAN unless menu_option_chosen != index}" + menu_option.description)
            end

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
                @menu_options[menu_option_chosen].action.call
            end
        end
    end
end