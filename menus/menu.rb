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
            clear_line(0, 0)
            puts("#{@title}#{COLORS[RESET]}")

            @menu_options.each_with_index do |menu_option, index|
                clear_line(index + 2, 0)
                puts("#{COLORS[CYAN] unless menu_option_chosen != index}" + menu_option.description + "#{COLORS[RESET]}")
            end

            clear_line(@menu_options.length + 3, 0)
            puts "#{@details}#{COLORS[RESET]}"

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

    private 

    def clear_line(x, y)
        print "\e[#{x};#{y}H"
        print "\e[2K"
    end
end