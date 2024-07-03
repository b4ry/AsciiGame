require_relative '../constants/constants.rb'
require_relative '../resumable_thread'

class Menu
    def initialize(path, title) 
        @title = "#{path + ' -> ' unless path == nil}#{title}"
    end

    def draw
        user_input = nil
        last_menu_option_index = @menu_options.length - 1;

        @menu_option_chosen = 0
        @colors = [COLORS[GREEN], COLORS[RED], COLORS[CYAN]]
        @current_color_index = 0

        print(HIDE_CURSOR)

        ui_thread = ResumableThread.new(lambda { |id| draw_ui(id) })
        ui_thread.start

        while(true)
            user_input = STDIN.getch

            if(user_input == "s")
                if(@menu_option_chosen == last_menu_option_index)
                    @menu_option_chosen = 0
                else
                    @menu_option_chosen += 1
                end
            elsif(user_input == "w")
                if(@menu_option_chosen == 0)
                    @menu_option_chosen = last_menu_option_index
                else
                    @menu_option_chosen -= 1
                end
            elsif(user_input == "\r")
                ui_thread.stop

                if(@menu_option_chosen == last_menu_option_index)
                    system(CLEAR_SCREEN)
                    break
                end
                
                @menu_options[@menu_option_chosen].action.call

                ui_thread.restart
            end

            system(CLEAR_SCREEN)

            puts("#{@colors[@current_color_index]}#{@title}#{COLORS[RESET]}")

            @menu_options.each_with_index do |menu_option, index|
                puts("#{COLORS[CYAN] unless @menu_option_chosen != index}" + menu_option.description + "#{COLORS[RESET]}")
            end

            puts("\n#{@details}#{COLORS[RESET]}")
        end

        ui_thread.kill
    end

    def draw_ui(id)
        system(CLEAR_SCREEN)

        @current_color_index = (@current_color_index + 1) % @colors.length
        puts("#{@colors[@current_color_index]}#{@title}#{COLORS[RESET]}")
        puts("#{id}")

        @menu_options.each_with_index do |menu_option, index|
            puts("#{COLORS[CYAN] unless @menu_option_chosen != index}" + menu_option.description + "#{COLORS[RESET]}")
        end

        puts("\n#{@details}#{COLORS[RESET]}")
    end
end