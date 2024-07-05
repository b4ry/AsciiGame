require_relative '../constants/constants'

class TerminalHelper
    def self.go_to(x, y)
        print "\e[#{x};#{y}H"
    end

    def self.clear_line(x, y)
        print "\e[#{x};#{y}H"
        print "\e[2K"
    end

    def self.display_text_at(text, x, y)
        TerminalHelper.clear_line(x, y)
        puts(text)
    end

    def self.hide_cursor()
        print(HIDE_CURSOR)
    end

    def self.show_cursor()
        print(SHOW_CURSOR)
    end

    def self.clear_screen()
        system(CLEAR_SCREEN)
    end
end