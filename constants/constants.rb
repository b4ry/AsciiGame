BLACK = "BLACK"
RED = "RED"
GREEN = "GREEN"
YELLOW = "YELLOW"
BLUE = "BLUE"
CYAN = "CYAN"
WHITE = "WHITE"
RESET = "RESET"

CLEAR_SCREEN = "cls"

# ANSI escape codes
COLORS = {
    BLACK => "\e[30m",
    RED => "\e[31m",
    GREEN => "\e[32m",
    YELLOW => "\e[0;33m",
    BLUE => "\e[0;34m",
    CYAN => "\e[36m",
    WHITE => "\e[0;37m",
    RESET => "\e[0m"
}

HIDE_CURSOR = "\e[?25l"
SHOW_CURSOR = "\e[?25h"