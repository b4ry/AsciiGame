BLACK = "BLACK"
RED = "RED"
GREEN = "GREEN"
YELLOW = "YELLOW"
BLUE = "BLUE"
CYAN = "CYAN"
WHITE = "WHITE"
DARK_BLUE = "DARK_BLUE"
LIGHT_GREEN = "LIGHT_GREEN"
BROWN = "BROWN"
RESET = "RESET"

CLEAR_SCREEN = "cls"

# ANSI escape codes
COLORS = {
    BLACK => "\e[30m",
    RED => "\e[31m",
    LIGHT_GREEN => "\e[32m",
    YELLOW => "\e[0;33m",
    BLUE => "\e[0;34m",
    CYAN => "\e[36m",
    WHITE => "\e[0;37m",
    DARK_BLUE => "\e[38;5;18m",
    GREEN => "\e[38;5;70m",
    BROWN => "\e[38;5;94m",
    RESET => "\e[0m"
}

BG_COLORS = {
    DARK_BLUE => "\e[48;5;18m",
    BLUE => "\e[44m",
    YELLOW => "\e[43m",
    LIGHT_GREEN => "\e[42m",
    GREEN => "\e[48;5;70m",
    BROWN => "\e[48;5;94m",
    WHITE => "\e[47m",
    BLACK => "\e[48;5;235m"
}

HIDE_CURSOR = "\e[?25l"
SHOW_CURSOR = "\e[?25h"